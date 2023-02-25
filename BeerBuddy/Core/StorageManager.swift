//
//  StorageManager.swift
//  BeerBuddy
//
//  Created by Tim on 25.01.2023.
//

import FirebaseStorage
import Foundation

final class StorageManager {
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadURL
    }
    
    static let shared = StorageManager()
    private init() {}
    
    private let storage = Storage.storage().reference()
    
    public typealias CompletionBlock = (Result<String, Error>) -> Void
    
    /// Upload picture to firebase storage and return url string to download
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping CompletionBlock) {
        storage.child("images/\(fileName)").putData(data) { [weak self] _, error in
            guard error == nil else { return completion(.failure(StorageErrors.failedToUpload)) }
            self?.storage.child("images/\(fileName)").downloadURL(completion: { url, _ in
                guard let url else { return completion(.failure(StorageErrors.failedToGetDownloadURL)) }
                completion(.success(url.absoluteString))
            })
        }
    }
    
    /// upload image that will be sent in a conversation message
    public func uploadMessagePhoto(with data: Data, fileName: String, completion: @escaping CompletionBlock) {
        storage.child("message_images/\(fileName)").putData(data) { [weak self] _, error in
            guard error == nil else { return completion(.failure(StorageErrors.failedToUpload)) }
            self?.storage.child("message_images/\(fileName)").downloadURL(completion: { url, _ in
                guard let url else { return completion(.failure(StorageErrors.failedToGetDownloadURL)) }
                completion(.success(url.absoluteString))
            })
        }
    }
    
    /// upload video that will be sent in a conversation message
    public func uploadMessageVideo(with url: URL, fileName: String, completion: @escaping CompletionBlock) {
        storage.child("message_videos/\(fileName)").putFile(from: url) { [weak self] _, error in
            guard error == nil else { return completion(.failure(StorageErrors.failedToUpload)) }
            self?.storage.child("message_videos/\(fileName)").downloadURL(completion: { url, _ in
                guard let url else { return completion(.failure(StorageErrors.failedToGetDownloadURL)) }
                completion(.success(url.absoluteString))
            })
        }
    }
    
    /// returns URL for image download as String
    public func downloadURL(for path: String, completion: @escaping CompletionBlock) {
        storage.child(path).downloadURL(completion: { url, error in
            guard let url, error == nil else { return completion(.failure(StorageErrors.failedToGetDownloadURL)) }
            completion(.success(url.absoluteString))
        })
    }
    
    public func downloadImage(from url: URL, completion: @escaping (Data) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            guard let data, error == nil else { return }
            completion(data)
        }).resume()
    }
}
