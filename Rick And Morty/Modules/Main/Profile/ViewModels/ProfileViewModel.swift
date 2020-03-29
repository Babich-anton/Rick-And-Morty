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
    
    let disposebag = DisposeBag()
    
    var user: BehaviorRelay<User?> = BehaviorRelay<User?>(value: nil)
    
    let nameViewModel = NameViewModel()
    let emailViewModel = ProfileEmailViewModel()
    let newPasswordViewModel = ProfilePasswordViewModel()
    let confirmPasswordViewModel = ProfilePasswordViewModel()
    
    let isImageUpdated: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    let isUpdated: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    let errorMessage: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    
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
    
    func update() {
        
        if isValid() {
            let group = DispatchGroup()
            
            if user.value?.displayName != nameViewModel.data.value {
                
                let request = Auth.auth().currentUser?.createProfileChangeRequest()
                request?.displayName = nameViewModel.data.value
                group.enter()
                isUpdated.accept(false)
                
                request?.commitChanges { error in
                    if let error = error {
                        self.errorMessage.accept(error.localizedDescription)
                    }
                    
                    group.leave()
                }
            }
            
            if user.value?.email != emailViewModel.data.value {
                
                group.enter()
                isUpdated.accept(false)
                
                user.value?.updateEmail(to: emailViewModel.data.value) { error in
                    if let error = error {
                        self.errorMessage.accept(error.localizedDescription)
                    }
                    
                    group.leave()
                }
            }
            
            if newPasswordViewModel.data.value == confirmPasswordViewModel.data.value && !confirmPasswordViewModel.data.value.isEmpty {
                
                group.enter()
                isUpdated.accept(false)
                
                user.value?.updatePassword(to: confirmPasswordViewModel.data.value) { error in
                    if let error = error {
                        self.errorMessage.accept(error.localizedDescription)
                    }
                    
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                showMessage(with: self.errorMessage.value.isEmpty ? "User successfully updated" : self.errorMessage.value)
                self.isUpdated.accept(true)
            }
            
            self.errorMessage.accept("")
        } else {
            var message = ""
            
            if !nameViewModel.errorValue.value.isEmpty {
                message = nameViewModel.errorValue.value
            } else if !emailViewModel.errorValue.value.isEmpty {
                message = emailViewModel.errorValue.value
            } else if !newPasswordViewModel.errorValue.value.isEmpty {
                message = newPasswordViewModel.errorValue.value
            } else if !confirmPasswordViewModel.errorValue.value.isEmpty {
                message = confirmPasswordViewModel.errorValue.value
            }
            
            showMessage(with: message)
            isUpdated.accept(true)
        }
    }
    
    private func isValid() -> Bool {
        
        return nameViewModel.validateCredentials() &&
            emailViewModel.validateCredentials() &&
            newPasswordViewModel.validateCredentials() &&
            confirmPasswordViewModel.validateCredentials()
    }
    
    deinit {
        if let handle = self.handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
