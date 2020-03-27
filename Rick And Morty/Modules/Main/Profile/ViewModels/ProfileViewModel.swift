//
//  UserViewModel.swift
//  Rick And Morty
//
//  Created by Anton Babich on 27.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import FirebaseAuth
import RxCocoa
import RxSwift

class ProfileViewModel: NSObject {
    
    var handle: AuthStateDidChangeListenerHandle?
    
    var user: BehaviorRelay<User?> = BehaviorRelay<User?>(value: nil)
    
    // add text fields change text handlers and then update with validation
    // bug with loading data - add spinner when data loading
    
    override init() {
        super.init()
        
        self.handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.user.accept(user)
            } else {
                self.user.accept(nil)
            }
        }
    }
    
    func update(user: User) {
        
        
//        let request = Auth.auth().currentUser?.createProfileChangeRequest()
//
//        Auth.auth().updateCurrentUser(user) { error in
//            if let error = error {
//                showMessage(with: error.localizedDescription)
//            }
//        }
    }
    
    deinit {
        if let handle = self.handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
