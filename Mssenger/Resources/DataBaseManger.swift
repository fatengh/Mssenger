//
//  DataBaseManger.swift
//  Mssenger
//
//  Created by administrator on 05/01/2022.
//

import Foundation
import FirebaseDatabase

final class DataBaseManger{
    
    static let shared = DataBaseManger()
    
    private let database = Database.database().reference()
    
    static func safe (emailAdd: String) -> String{
        var safe = emailAdd.replacingOccurrences(of: ".", with: "-")
        safe = safe.replacingOccurrences(of: "@", with: "-")
        return safe
    }
}

extension DataBaseManger{
    
    
    // not same email
    public func checkNewUserExists(with email: String,
                                   completion: @escaping ((Bool) -> Void)){
        
        var safe = email.replacingOccurrences(of: ".", with: "-")
        safe = safe.replacingOccurrences(of: "@", with: "-")
        database.child(safe).observeSingleEvent(of: .value, with: {snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            
            completion(true)
        })
        
    }
    
    public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
           database.child("users").observeSingleEvent(of: .value, with: { snapshot in
               guard let value = snapshot.value as? [[String: String]] else {
                   completion(.failure(DatabaseError.failedFetch))
                   return
               }

               completion(.success(value))
           })
       }
    
    public enum DatabaseError: Error {
            case failedFetch

            public var localizedDescription: String {
                switch self {
                case .failedFetch:
                    return "This failed"
                }
            }
        }

    // insert new user
    public func insertNewUser(with user: ChatUser, completion: @escaping (Bool) -> Void){
        database.child(user.safe).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName,
        ], withCompletionBlock:  { error , _ in
            guard error == nil else {
                print("failed to write to database")
                completion(false)
                return
            }
            self.database.child("users").observeSingleEvent(of: .value, with: { snapshot in
                if var usersCollection = snapshot.value as? [[String: String]] {
                    let newElement = [
                        "name": user.firstName + " " + user.lastName,
                        "email": user.safe
                    ]
                    usersCollection.append(newElement)
                    self.database.child("users").setValue(usersCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        
                        completion(true)
                    })
                }
                else{
                    let newCollection: [[String: String]] = [
                        [
                            "name": user.firstName + " " + user.lastName,
                            "email": user.safe
                        ]
                    ]
                    self.database.child("users").setValue(newCollection, withCompletionBlock: {error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                }
            })
        })
    }
}

    struct ChatUser{
        let firstName: String
        let lastName: String
        let emailAdd: String
        var safe : String{
            var safe = emailAdd.replacingOccurrences(of: ".", with: "-")
            safe = safe.replacingOccurrences(of: "@", with: "-")
            return safe
        }
        
        var profilePicFileName: String {
           return "\(safe)_profile_picture.png"
        }
    }

