//
//  DatabaseManager.swift
//  PeakyChats
//
//  Created by Nishant  Kushwaha on 14/05/21.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager{
    
    public static let shared = DatabaseManager()

        private let database = Database.database().reference()

       
}

// Account Management
extension DatabaseManager{
    
    public func userExists(with email: String,
                           completion:@escaping(Bool)->Void){
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
            safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? String != nil else{
                completion(false)
                return
            }
            
            completion(true)
        })
    }
    
    ///Insert new user to databse
    public func insertUser(with user:ChatAppUser){
        database.child(user.safeEmail).setValue([
            "first_name" : user.firstName,
            "last_name" :user.lastName
        
        ])
        
    }
}
struct ChatAppUser {
    let firstName:String
    let lastName:String
    let emailId:String
    
    
    var safeEmail: String{
        var safeEmail = emailId.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
        
    }
    
    
    
}
