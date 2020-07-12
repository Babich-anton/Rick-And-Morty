//
//  LoginViewModel.swift
//  Rick And Morty
//
//  Created by Anton Babich on 15.03.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import RxCocoa
import RxSwift

class LoginViewModel: NSObject, ViewModel {
    
    private let model = Login()
    private let disposeBag = DisposeBag()
    
    internal let emailViewModel = EmailViewModel()
    internal let passwordViewModel = PasswordViewModel()
    
    internal let isSignedIn: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    private let errorMessage: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    
    weak var delegate: LoginViewProtocol?
    
    private func validateCredentials() -> Bool {
        return emailViewModel.validateCredentials() && passwordViewModel.validateCredentials()
    }
    
    func bind(loginButton: UIButton) {
        loginButton.rx.tap.do(onNext: { [weak self] in
            self?.delegate?.loginTapped()
        }).subscribe(onNext: { [weak self] in
            guard let `self` = self else {
                return
            }

            if self.validateCredentials() {
                self.loginUser()
            } else {
                if !self.emailViewModel.errorValue.value.isEmpty {
                    showMessage(with: self.emailViewModel.errorValue.value)
                    self.passwordViewModel.data.accept("")
                } else if !self.passwordViewModel.errorValue.value.isEmpty {
                    showMessage(with: self.passwordViewModel.errorValue.value)
                    self.passwordViewModel.data.accept("")
                }
                
                self.delegate?.loginFailed()
            }
        }).disposed(by: disposeBag)
    }
    
    func bind(signUpButton: UIButton) {
        signUpButton.rx.tap.do(onNext: { [weak self] in
            self?.delegate?.signUpTapped()
        }).subscribe(onNext: { [weak self] in
            guard let `self` = self else {
                return
            }

            if self.validateCredentials() {
                self.signUp()
            } else {
                if !self.emailViewModel.errorValue.value.isEmpty {
                    showMessage(with: self.emailViewModel.errorValue.value)
                } else if !self.passwordViewModel.errorValue.value.isEmpty {
                    showMessage(with: self.passwordViewModel.errorValue.value)
                }
                
                self.delegate?.loginFailed()
            }
        }).disposed(by: disposeBag)
    }
    
    private func createObservers() {
        errorMessage.asObservable().bind { [weak self] value in
            self?.delegate?.show(errorMessage: value)
        }.disposed(by: disposeBag)
    }
    
    func loginUser() {
        self.model.email = self.emailViewModel.data.value
        self.model.password = self.passwordViewModel.data.value
        
        FirebaseManager.login(email: self.model.email,
                              password: self.model.password,
                              successHandler: { _ in
            self.delegate?.loginSuccess()
            self.isSignedIn.accept(true)
        }, errorHandler: { error in
            self.isSignedIn.accept(false)
            self.delegate?.loginFailed()
            showMessage(with: error.localizedDescription)
        })
    }
    
    func signUp() {
        self.model.email = self.emailViewModel.data.value
        self.model.password = self.passwordViewModel.data.value
        
        FirebaseManager.signUp(email: self.model.email,
                               password: self.model.password,
                               successHandler: { result in
            if result.additionalUserInfo?.isNewUser ?? false {
                self.delegate?.signUpSuccess()
            } else {
                self.delegate?.signUpFailed()
                showMessage(with: "Failed to create new user...")
            }
        }, errorHandler: { error in
            self.delegate?.signUpFailed()
            showMessage(with: error.localizedDescription)
        })
    }
    
    func getDisposeBag() -> DisposeBag {
        return disposeBag
    }
}
