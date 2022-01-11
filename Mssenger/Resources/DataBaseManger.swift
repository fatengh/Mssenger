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

extension DataBaseManger{
    
    public func createNewConversation(with otherUserEmail: String,  firstMessage: Msg, completion: @escaping (Bool) -> Void) {
        guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String else {
                 //   let currentNamme = UserDefaults.standard.value(forKey: "name") as? String
        
                        return
                }
        let safeEmail = DataBaseManger.safe(emailAdd: currentEmail)
        let ref = database.child("\(safeEmail)")
        ref.observeSingleEvent(of: .value, with: {snapshot in
            guard var userNode = snapshot.value as? [String: Any] else{
                completion(false)
                print("user not found")
                return
            }
            let messageDate = firstMessage.sentDate
            let dateString = ChatViewController.dateFormatter.string(from: messageDate)

            var message = ""

            switch firstMessage.kind {
                       case .text(let messageText):
                           message = messageText
                       case .attributedText(_):
                           break
                       case .photo(_):
                           break
                       case .video(_):
                           break
                       case .location(_):
                           break
                       case .emoji(_):
                           break
                       case .audio(_):
                           break
                       case .contact(_):
                           break
                       case .custom(_), .linkPreview(_):
                           break
                       }

                       let conversationId = "conversation_\(firstMessage.messageId)"

            
            
            
            let newConvData: [String: Any] = [
                "id": conversationId,
                "other_user_email": otherUserEmail,
//                "name": name,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                    
                ]
            ]
            if var coverstion = userNode["conversations"] as? [[String: Any]]{
                coverstion.append(newConvData)
                               userNode["conversations"] = coverstion
                               ref.setValue(userNode, withCompletionBlock: { [weak self] error, _ in
                                   guard error == nil else {
                                       completion(false)
                                       return
                                   }
                                   self?.finishCreatingConversation( conversationID: conversationId,  firstMessage: firstMessage, completion: completion)
                               })
            }else{
                userNode["conversations"] = [
                                   newConvData
                               ]

                               ref.setValue(userNode, withCompletionBlock: { [weak self] error, _ in
                                   guard error == nil else {
                                       completion(false)
                                       return
                                   }
                                   self?.finishCreatingConversation(conversationID: conversationId, firstMessage: firstMessage, completion: completion)
                                   
                               })
            }
        })
        }
        
    private func finishCreatingConversation(conversationID: String, firstMessage: Msg, completion: @escaping (Bool) -> Void) {
        let messageDate = firstMessage.sentDate
                let dateString = ChatViewController.dateFormatter.string(from: messageDate)
 
        var message = ""

        switch firstMessage.kind {
                   case .text(let messageText):
                       message = messageText
                   case .attributedText(_):
                       break
                   case .photo(_):
                       break
                   case .video(_):
                       break
                   case .location(_):
                       break
                   case .emoji(_):
                       break
                   case .audio(_):
                       break
                   case .contact(_):
                       break
                   case .custom(_), .linkPreview(_):
                       break
                   }


                guard let myEmmail = UserDefaults.standard.value(forKey: "email") as? String else {
                    completion(false)
                    return
                }

                let currentUserEmail = DataBaseManger.safe(emailAdd: myEmmail)
        
                 let collectionMessage: [String: Any] = [
                    "id": firstMessage.messageId,
                    "type": firstMessage.kind.messageKindString,
                    "content": message,
                    "date": dateString,
                    "sender_email": currentUserEmail,
                    "is_read": false,
                   
                ]

        
        let value: [String: Any] = [
            "messages": [
            collectionMessage
        ]]
        
        database.child("\(conversationID)").setValue(value, withCompletionBlock: {error ,
            _ in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        })
        
    }
    public func getAllConverstion(for email: String, completion: @escaping(Result<String, Error>) -> Void){
        
    }
    
    public func getallmsgs(with id: String, completion: @escaping(Result<String, Error>) -> Void){
        
    }
    
    public func sendmsgs(to converstion: String, msg: Msg, completion: @escaping (Bool) -> Void) {
        
        
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

