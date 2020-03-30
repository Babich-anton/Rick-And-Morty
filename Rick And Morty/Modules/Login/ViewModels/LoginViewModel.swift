//
//  LoginViewModel.swift
//  Rick And Morty
//
//  Created by Anton Babich on 15.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import FirebaseAuth
import RxCocoa
import RxSwift

class LoginViewModel {
    
    let model: LoginModel = LoginModel()
    let disposebag = DisposeBag()
    
    let emailViewModel = EmailViewModel()
    let passwordViewModel = PasswordViewModel()
    
    let isSignedIn: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    let isSuccess: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    let isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    let errorMessage: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    
    func validateCredentials() -> Bool {
        return emailViewModel.validateCredentials() && passwordViewModel.validateCredentials()
    }
    
    func loginUser() {
        
        self.model.email = self.emailViewModel.data.value
        self.model.password = self.passwordViewModel.data.value
        
        self.isLoading.accept(false)
        
        Auth.auth().signIn(withEmail: self.model.email, password: self.model.password) { user, error in
            
            if let error = error {
                self.isLoading.accept(true)
                self.isSuccess.accept(false)
                showMessage(with: error.localizedDescription)
            } else {
                self.isLoading.accept(true)
                self.isSuccess.accept(true)
                self.isSignedIn.accept(true)
            }
        }
    }
    
    func signUp() {
        
        self.model.email = self.emailViewModel.data.value
        self.model.password = self.passwordViewModel.data.value
        
        self.isLoading.accept(false)
        
        Auth.auth().createUser(withEmail: self.model.email, password: self.model.password) { user, error in
            
            if let error = error {
                self.isLoading.accept(true)
                self.isSuccess.accept(false)
                showMessage(with: error.localizedDescription)
            } else {
                self.isLoading.accept(true)
                
                if user?.additionalUserInfo?.isNewUser ?? false {
                    showMessage(with: "New user created successfully. Please sign in to the app.")
                    self.isSuccess.accept(true)
                } else {
                    showMessage(with: "Failed to create new user..")
                    self.isSuccess.accept(false)
                }
            }
        }
    }
}
