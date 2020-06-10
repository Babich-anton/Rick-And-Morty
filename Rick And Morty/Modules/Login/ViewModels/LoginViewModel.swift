//
//  LoginViewModel.swift
//  Rick And Morty
//
//  Created by Anton Babich on 15.03.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import RxCocoa
import RxSwift

class LoginViewModel {
    
    let model = Login()
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
        
        FirebaseManager.login(email: self.model.email,
                              password: self.model.password,
                              successHandler: { _ in
            self.isLoading.accept(true)
            self.isSuccess.accept(true)
            self.isSignedIn.accept(true)
        }, errorHandler: { error in
            self.isLoading.accept(true)
            self.isSuccess.accept(false)
            showMessage(with: error.localizedDescription)
        })
    }
    
    func signUp() {
        self.model.email = self.emailViewModel.data.value
        self.model.password = self.passwordViewModel.data.value
        
        self.isLoading.accept(false)
        
        FirebaseManager.signUp(email: self.model.email,
                               password: self.model.password,
                               successHandler: { result in
            self.isLoading.accept(true)
            
            if result.additionalUserInfo?.isNewUser ?? false {
                showMessage(with: "New user created successfully. Please sign in to the app.")
                self.isSuccess.accept(true)
            } else {
                showMessage(with: "Failed to create new user..")
                self.isSuccess.accept(false)
            }
        }, errorHandler: { error in
            self.isLoading.accept(true)
            self.isSuccess.accept(false)
            showMessage(with: error.localizedDescription)
        })
    }
}
