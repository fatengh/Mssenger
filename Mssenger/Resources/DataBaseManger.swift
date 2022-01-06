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
    
    // insert new user
    public func insertNewUser(with user: ChatUser){
        database.child(user.safe).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName,
        ])
        
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
    }

