//
//  FirebaseNetwork.swift
//  BeerBuddy
//
//  Created by Ke4a on 27.02.2023.
//

import CoreLocation
import Firebase
import Foundation
import MessageKit

class FirebaseNetwork {
    private enum DatabaseError: Error {
        case failed
    }
    private lazy var database = Database.database().reference()
    private lazy var senderEmail = UserDefaults.standard.value(forKey: "email") as? String
}

extension FirebaseNetwork: NetworkProtocol {
    func safeEmail(email: String?) -> String {
        guard let email else { return "" }
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }

    func getProfilePicturePath(email: String) -> String {
        return "images/" + safeEmail(email: email) + "_profile_picture.png"
    }
}

// MARK: - Sending messages / conversations

extension FirebaseNetwork {
    func createNewConversation(with otherUserEmail: String,
                               name: String,
                               firstMessage: Message,
                               completion: @escaping (Bool) -> Void) {

        let conversationId = "conversation_\(firstMessage.messageId)"
        let newMessage: [String: Any] = [:]
        let newConversation: [String: Any] = ["messages": newMessage, "isPinned": false]

        database.child("conversations/\(conversationId)").setValue(newConversation) { [weak self] error, _ in
            guard error == nil else { return completion(false) }
            self?.sendMessage(to: conversationId,
                              otherUserEmail: otherUserEmail,
                              name: name,
                              message: firstMessage) { success in
                return completion(success)
            }
        }
    }

    func getAllConversations(for email: String, completion: @escaping (Result<[Conversation], Error>) -> Void) {
        database.child("users/\(email)/conversations").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else {
                return completion(.failure(DatabaseError.failed))
            }

            let conversations: [Conversation] = value.compactMap({ dictionary in
                guard let id = dictionary["id"] as? String,
                      let name = dictionary["name"] as? String,
                      let otherUserEmail = dictionary["other_user_email"] as? String,
                      let latestMessage = dictionary["latest_message"] as? [String: Any],
                      let date = latestMessage["date"] as? String,
                      let message = latestMessage["message"] as? String,
                      let isPinned = dictionary["isPinned"] as? Bool
                else {
                    return nil
                }
                let latestMessageObject = LatestMessage(date: date, text: message)
                return Conversation(id: id,
                                    name: name,
                                    otherUserEmail: otherUserEmail,
                                    latestMessage: latestMessageObject,
                                    isPinned: isPinned)
            })
            completion(.success(conversations))
        })
    }

    func getAllMessagesForConversation(with id: String,
                                       completion: @escaping (Result<[Message], Error>) -> Void) {
        database.child("conversations/\(id)/messages").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else {
                return completion(.failure(DatabaseError.failed))
            }

            let messages: [Message] = value.compactMap({ dictionary in
                guard let id = dictionary["id"] as? String,
                      let name = dictionary["name"] as? String,
                      let otherUserEmail = dictionary["sender_email"] as? String,
                      let content = dictionary["content"] as? String,
                      let dateString = dictionary["date"] as? String,
                      let kind = dictionary["kind"] as? String,
                      let date = DateFormatterHelper.dateFormatter.date(from: dateString)
                else {
                    return nil
                }

                let sender = Sender(senderId: otherUserEmail, displayName: name, photoURL: "")

                var kindInput: MessageKind?

                switch kind {
                case "photo":
                    guard let url = URL(string: content),
                          let placeholder = UIImage(systemName: "photo") else { return nil }
                    let media = Media(url: url, placeholderImage: placeholder, size: CGSize(width: 200, height: 200))
                    kindInput = .photo(media)
                case "video":
                    guard let url = URL(string: content),
                          let placeholder = UIImage(systemName: "video") else { return nil }
                    let media = Media(url: url, placeholderImage: placeholder, size: CGSize(width: 200, height: 200))
                    kindInput = .video(media)
                case "text":
                    kindInput = .text(content)
                case "location":
                    let coordinatesStrings = content.components(separatedBy: ",")
                    guard let latitude = Double(coordinatesStrings[0]),
                          let longitude = Double(coordinatesStrings[1]) else {
                        return nil
                    }
                    let coordinates = CLLocation(latitude: latitude, longitude: longitude)
                    let locationItem = Location(location: coordinates, size: CGSize(width: 200, height: 200))
                    kindInput = .location(locationItem)
                default:
                    break
                }
                guard let kindInput else { return nil }
                return Message(sender: sender, messageId: id, sentDate: date, kind: kindInput)
            })
            completion(.success(messages))
        })
    }

    func sendMessage(to conversation: String,
                     otherUserEmail: String,
                     name: String,
                     message: Message,
                     completion: @escaping (Bool) -> Void) {
        guard let currentName = UserDefaults.standard.value(forKey: "name") as? String else { return }
        let safeEmail = safeEmail(email: senderEmail)
        var content = ""
        let messageDateString = DateFormatterHelper.dateFormatter.string(from: message.sentDate)

        switch message.kind {

        case .text(let messageText):
            content = messageText
        case .photo(let mediaItem):
            if let targetUrlString = mediaItem.url?.absoluteString { content = targetUrlString }
        case .video(let mediaItem):
            if let targetUrlString = mediaItem.url?.absoluteString { content = targetUrlString }
        case .location(let locationData):
            let location = locationData.location
            content = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        default:
            break
        }

        let latestMessageUpdatedValue: [String: Any] = [
            "date": messageDateString,
            "message": content
        ]

        let newMessage: [String: Any] = [
            "id": message.messageId,
            "kind": message.kind.description,
            "content": content,
            "date": messageDateString,
            "sender_email": safeEmail,
            "name": name
        ]

        let newConversationData: [String: Any] = [
            "id": conversation,
            "other_user_email": otherUserEmail,
            "name": name,
            "isPinned": false,
            "latest_message": [
                "date": messageDateString,
                "message": content
            ]
        ]

        let recipientNewConversationData: [String: Any] = [
            "id": conversation,
            "other_user_email": safeEmail,
            "name": currentName,
            "isPinned": false,
            "latest_message": [
                "date": messageDateString,
                "message": content
            ]
        ]
        let ref = database.child("conversations/\(conversation)/messages")
        ref.observeSingleEvent(of: .value, with: { [weak self] snapshot in
            var updatedMessages = [[String: Any]]()
            if let existingMessages = snapshot.value as? [[String: Any]] {
                updatedMessages = existingMessages
                updatedMessages.append(newMessage)
            } else {
                updatedMessages = [newMessage]
            }

            ref.setValue(updatedMessages) { error, _ in
                guard error == nil else { return completion(false) }

                let path = "users/\(safeEmail)/conversations"
                self?.database.child(path).observeSingleEvent(of: .value) { [weak self] snapshot in
                    var targetConversation = [String: Any]()
                    if var conversations = snapshot.value as? [[String: Any]] {
                        for (index, conversationEntry) in conversations.enumerated() where
                        conversationEntry["id"] as? String == conversation {
                            print("we found convo, rewriting it")
                            targetConversation = conversations[index]
                            targetConversation["latest_message"] = latestMessageUpdatedValue
                            conversations[index] = targetConversation
                            self?.database.child(path).setValue(conversations)
                            completion(true)
                            break
                        }
                        guard targetConversation.isEmpty else { return }
                        print("we did not found convo, appending to others")
                        conversations.append(newConversationData)
                        self?.database.child(path).setValue(conversations)
                        completion(true)
                    } else {
                        print("we did not found any convos, creating new")
                        self?.database.child(path).setValue([newConversationData])
                        completion(true)
                    }
                }

                let otherUserPath = "users/\(otherUserEmail)/conversations"
                self?.database.child(otherUserPath).observeSingleEvent(of: .value, with: { [weak self] snapshot in
                    var targetConversation = [String: Any]()
                    if var conversations = snapshot.value as? [[String: Any]] {
                        for (index, conversationEntry) in conversations.enumerated() where
                        conversationEntry["id"] as? String == conversation {
                            print("we found other users convo, rewriting it")
                            targetConversation = conversations[index]
                            targetConversation["latest_message"] = latestMessageUpdatedValue
                            conversations[index] = targetConversation
                            self?.database.child(otherUserPath).setValue(conversations)
                            completion(true)
                            break
                        }
                        guard targetConversation.isEmpty else { return }
                        print("we did not found other users convo, appending to others")
                        conversations.append(recipientNewConversationData)
                        self?.database.child(otherUserPath).setValue(conversations)
                        completion(true)
                    } else {
                        print("we did not found other users convo, creating new")
                        self?.database.child(otherUserPath).setValue([recipientNewConversationData])
                        completion(true)
                    }
                })
            }
        })
    }

    func deleteConversation(id: String, completion: @escaping (Bool) -> Void) {
        let safeEmail = safeEmail(email: senderEmail)

        let ref = database.child("users/\(safeEmail)/conversations")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard var conversations = snapshot.value as? [[String: Any]] else { return completion(false) }
            for (index, conversation) in conversations.enumerated() {
                guard let conversationId = conversation["id"] as? String else { return }
                if conversationId == id {
                    conversations.remove(at: index)
                    break
                }
            }
            ref.setValue(conversations, withCompletionBlock: { error, _ in
                return completion(error == nil)
            })
        })
    }

    func conversationExists(with otherUserEmail: String, completion: @escaping CompletionBlockForString) {
        let safeSenderEmail = safeEmail(email: senderEmail)
        let safeOtherUserEmail = safeEmail(email: otherUserEmail)

        database.child("users/\(safeOtherUserEmail)/conversations").observeSingleEvent(of: .value, with: { snapshot in
            guard let collection = snapshot.value as? [[String: Any]] else {
                return completion(.failure(DatabaseError.failed))
            }

            if let existingConversation = collection.first( where: {
                guard let targetSenderEmail = $0["other_user_email"] as? String else { return false }
                return safeSenderEmail == targetSenderEmail }) {
                guard let id = existingConversation["id"] as? String else {
                    return completion(.failure(DatabaseError.failed))
                }
                return completion(.success(id))
            }
            return completion(.failure(DatabaseError.failed))
        })
    }
}

// MARK: - Account Managment

extension FirebaseNetwork {
    func userExists(with email: String, completion: @escaping ((Bool) -> Void)) {

        let safeEmail = safeEmail(email: email)
        database.child("users/\(safeEmail)").observeSingleEvent(of: .value, with: { snapshot in
            return completion(snapshot.value as? [String: Any] != nil)
        })
    }

    func insertUser(with user: User, completion: @escaping (Bool) -> Void) {

        let newElement: [String: Any] = ["name": user.name,
                                         "email": user.safeEmail,
                                         "sex": user.sex.rawValue,
                                         "birthDate": user.birthDate,
                                         "smoking": user.smoking.rawValue,
                                         "interests": user.interestsStrings,
                                         "alcohols": user.alcoholStrings,
                                         "matches": user.matches,
                                         "possibleMatches": user.possibleMatches,
                                         "rejectedUsers": user.rejectedUsers
        ]

        //        database.child("users/\(user.safeEmail)").setValue(newElement) { [weak self] error, _ in
        //            guard error == nil else { return completion(false) }
        //            guard let self else { return }
        //
        database.child("users").observeSingleEvent(of: .value, with: { snapshot in
            var newOrUpdatedCollection = [String: Any]()

            if let usersCollection = snapshot.value as? [String: Any] {
                newOrUpdatedCollection = usersCollection
            }

            newOrUpdatedCollection[user.safeEmail] = newElement

            self.database.child("users").setValue(newOrUpdatedCollection) { error, _ in
                return completion(error == nil)
            }
        })
        //        }
    }

    func getAllUsers(completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        database.child("users").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else {
                return completion(.failure(DatabaseError.failed))
            }
            completion(.success(value))
        })
    }

    func getAllMatches(for email: String, completion: @escaping (Result<[String], Error>) -> Void) {
        let safeEmail = safeEmail(email: email)

        database.child("users/\(safeEmail)/matches").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [String] else {
                return completion(.failure(DatabaseError.failed))
            }
            completion(.success(value))
        })
    }

    func getUser(with email: String, completion: @escaping (Result<User, Error>) -> Void) {
        let safeEmail = safeEmail(email: email)

        database.child("users/\(safeEmail)").observe(.value, with: { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else {
                return completion(.failure(DatabaseError.failed))
            }
            guard let name = dictionary["name"] as? String,
                  let email = dictionary["email"] as? String,
                  let sex = dictionary["sex"] as? String,
                  let birthDate = dictionary["birthDate"] as? Double,
                  let smoking = dictionary["smoking"] as? String,
                  let location = dictionary["smoking"] as? String,
                  let interests = dictionary["interests"] as? [String],
                  let alcohols = dictionary["alcohols"] as? [String],
                  let matches = dictionary["matches"] as? [String],
                  let possibleMatches = dictionary["possibleMatches"] as? [String],
                  let rejectedUsers = dictionary["rejectedUsers"] as? [String]
            else {
                return completion(.failure(DatabaseError.failed))
            }

            let user = User(name: name,
                            emailAddress: email,
                            sex: sex,
                            birthDate: birthDate,
                            smoking: smoking,
                            location: location,
                            interestsStrings: interests,
                            matches: matches,
                            alcoholStrings: alcohols,
                            possibleMatches: possibleMatches,
                            rejectedUsers: rejectedUsers)
            completion(.success(user))
        })
    }

    func getDataFor(path: String, completion: @escaping (Result<Any, Error>) -> Void) {
        database.child(path).observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value else { return completion(.failure(DatabaseError.failed)) }
            completion(.success(value))
        })
    }
}
