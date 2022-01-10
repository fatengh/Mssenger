//
//  StorageManager.swift
//  Mssenger
//
//  Created by administrator on 09/01/2022.
//

import Foundation
import FirebaseStorage



final class StorageManager {
    
static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
   
    
    public typealias photoCompl = (Result<String, Error>) -> Void
    
    public func uploadProfilePhoto(with data: Data, fileName: String, completion: @escaping photoCompl){
        storage.child("images/\(fileName)").putData(data, metadata: nil) { metadata, error in
            guard error == nil else {
                print("failed upload pic data to firebase")
                completion(.failure(StorageErrors.failedUpload))
                return
            }
            
            self.storage.child("images/\(fileName)").downloadURL { url, error in
                guard let url = url else {
                    print("Failed to get download url")
                    completion(.failure(StorageErrors.failedGetUrl))
                    return
                }
                
                let urlString = url.absoluteString
                
                print("download url: \(urlString)")
                
                completion(.success(urlString))
            }
        }
        
    }
    
    public func downloadURL(for path: String,completion: @escaping (Result<URL, Error>) -> Void) {
        let reference = storage.child(path)
        
     
        reference.downloadURL { url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedGetUrl))
                return
            }
            completion(.success(url))
        }
        
    }
    
    public enum StorageErrors: Error {
        case failedUpload
        case failedGetUrl
    }
    
    
}
