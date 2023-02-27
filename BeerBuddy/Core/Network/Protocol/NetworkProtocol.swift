//
//  NetworkProtocol.swift
//  BeerBuddy
//
//  Created by Ke4a on 27.02.2023.
//

import Foundation

protocol NetworkProtocol {
    typealias CompletionBlockForString = (Result<String, Error>) -> Void
    
    // MARK: - Base Functions
    
    func safeEmail(email: String?) -> String
    func getProfilePicturePath(email: String) -> String
    
    // MARK: - Sending messages / conversations
    
    /// Creates a new conversation with target user email and first message sent
    func createNewConversation(with otherUserEmail: String,
                               name: String,
                               firstMessage: Message,
                               completion: @escaping (Bool) -> Void)
    /// Fetches and returns all conversations for the user with passed in email
    func getAllConversations(for email: String, completion: @escaping (Result<[Conversation], Error>) -> Void)
    /// Gets all messages for a given conversation
    func getAllMessagesForConversation(with id: String,
                                       completion: @escaping (Result<[Message], Error>) -> Void)
    /// Sends a message with target conversation and message
    func sendMessage(to conversation: String,
                     otherUserEmail: String,
                     name: String,
                     message: Message,
                     completion: @escaping (Bool) -> Void)
    func deleteConversation(id: String, completion: @escaping (Bool) -> Void)
    func conversationExists(with otherUserEmail: String, completion: @escaping CompletionBlockForString)
    
    // MARK: - Account Managment
    
    func userExists(with email: String, completion: @escaping ((Bool) -> Void))
    func insertUser(with user: User, completion: @escaping (Bool) -> Void)
    func getAllUsers(completion: @escaping (Result<[[String: Any]], Error>) -> Void)
    func getAllMatches(for email: String, completion: @escaping (Result<[String], Error>) -> Void)
    func getUser(with email: String, completion: @escaping (Result<User, Error>) -> Void)
    func getDataFor(path: String, completion: @escaping (Result<Any, Error>) -> Void)
}
