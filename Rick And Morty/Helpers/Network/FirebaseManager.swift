//
//  FirebaseManager.swift
//  Rick And Morty
//
//  Created by Anton Babich on 11.06.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import FirebaseAuth

struct FirebaseManager {
    
    static func login(email: String,
                       password: String,
                       successHandler: @escaping ((AuthDataResult) -> Void),
                       errorHandler: @escaping ((Error) -> Void)) {
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let user = user {
                successHandler(user)
            } else if let error = error {
                errorHandler(error)
            } else {
                let error = NSError(domain:"", code: 500, userInfo:[NSLocalizedDescriptionKey: "Internal Server Error"]) as Error
                errorHandler(error)
            }
        }
    }
    
    static func signUp(email: String,
                       password: String,
                       successHandler: @escaping ((AuthDataResult) -> Void),
                       errorHandler: @escaping ((Error) -> Void)) {
        
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if let user = user {
                successHandler(user)
            } else if let error = error {
                errorHandler(error)
            } else {
                let error = NSError(domain:"", code: 500, userInfo:[NSLocalizedDescriptionKey: "Internal Server Error"]) as Error
                errorHandler(error)
            }
        }
    }
    
    static func update(image: URL,
                       successHandler: @escaping (() -> Void),
                       errorHandler: @escaping ((Error) -> Void)) {
        
        let request = Auth.auth().currentUser?.createProfileChangeRequest()
        request?.photoURL = image
        
        request?.commitChanges { error in
            if let error = error {
                errorHandler(error)
            } else {
                successHandler()
            }
        }
    }
    
    static func update(name: String,
                       successHandler: @escaping (() -> Void),
                       errorHandler: @escaping ((Error) -> Void)) {
        
        let request = Auth.auth().currentUser?.createProfileChangeRequest()
        request?.displayName = name
        
        request?.commitChanges { error in
            if let error = error {
                errorHandler(error)
            } else {
                successHandler()
            }
        }
    }
    
    static func update(email: String,
                       user: User,
                       successHandler: @escaping (() -> Void),
                       errorHandler: @escaping ((Error) -> Void)) {
        
        user.updateEmail(to: email) { error in
            if let error = error {
                errorHandler(error)
                return
            }
            
            successHandler()
        }
    }
    
    static func update(password: String,
                       user: User,
                       successHandler: @escaping (() -> Void),
                       errorHandler: @escaping ((Error) -> Void)) {

        user.updatePassword(to: password) { error in
            if let error = error {
                errorHandler(error)
                return
            }
            
            successHandler()
        }
    }
}
