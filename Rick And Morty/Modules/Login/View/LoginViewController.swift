//
//  LoginViewController.swift
//  Rick And Morty
//
//  Created by Anton Babich on 15.03.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class LoginViewController: UIViewController {
    
    private var viewModel: LoginViewModel! // swiftlint:disable:this implicitly_unwrapped_optional
    private let disposeBag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var loginButton: TransitionButton!
    @IBOutlet private var signUpButton: TransitionButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        self.createViewModelBinding()
        self.createObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.emailTextField.rx.text.onNext("")
        self.viewModel.emailViewModel.data.accept("")
        self.passwordTextField.rx.text.onNext("")
        self.viewModel.passwordViewModel.data.accept("")
    }
    
    private func createViewModelBinding() {
        self.bindFields()
        self.bindLoginButton()
        self.bindSignUpButton()
    }
    
    private func bindFields() {
        self.emailTextField.rx.text.orEmpty
            .bind(to: viewModel.emailViewModel.data)
            .disposed(by: disposeBag)

        self.passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.passwordViewModel.data)
            .disposed(by: disposeBag)
    }
    
    private func bindLoginButton() {
        self.loginButton.rx.tap.do(onNext: { [weak self] in
            guard let `self` = self else {
                return
            }

            self.loginButton.startAnimation()
            self.loginButton.isEnabled = false
            self.signUpButton.isEnabled = false
        }).subscribe(onNext: { [weak self] in
            guard let `self` = self else {
                return
            }

            if self.viewModel.validateCredentials() {
                self.viewModel.loginUser()
            } else {
                if !self.viewModel.emailViewModel.errorValue.value.isEmpty {
                    
                    showMessage(with: self.viewModel.emailViewModel.errorValue.value)
                    
                    self.loginButton.stopAnimation(animationStyle: .normal, revertAfterDelay: 0.0)
                    self.passwordTextField.rx.text.onNext("")
                    self.viewModel.passwordViewModel.data.accept("")
                } else if !self.viewModel.passwordViewModel.errorValue.value.isEmpty {
                    
                    showMessage(with: self.viewModel.passwordViewModel.errorValue.value)
                    
                    self.loginButton.stopAnimation(animationStyle: .normal, revertAfterDelay: 0.0)
                    self.passwordTextField.rx.text.onNext("")
                    self.viewModel.passwordViewModel.data.accept("")
                }
                
                self.loginButton.isEnabled = true
                self.signUpButton.isEnabled = true
            }
        }).disposed(by: disposeBag)
    }
    
    private func bindSignUpButton() {
        self.signUpButton.rx.tap.do(onNext: { [weak self] in
            guard let `self` = self else {
                return
            }

            self.signUpButton.startAnimation()
            self.loginButton.isEnabled = false
            self.signUpButton.isEnabled = false
        }).subscribe(onNext: { [weak self] in
            guard let `self` = self else {
                return
            }

            if self.viewModel.validateCredentials() {
                self.viewModel.signUp()
            } else {
                if !self.viewModel.emailViewModel.errorValue.value.isEmpty {
                    
                    showMessage(with: self.viewModel.emailViewModel.errorValue.value)
                    self.signUpButton.stopAnimation(animationStyle: .normal, revertAfterDelay: 0.0)
                } else if !self.viewModel.passwordViewModel.errorValue.value.isEmpty {
                    
                    showMessage(with: self.viewModel.passwordViewModel.errorValue.value)
                    self.signUpButton.stopAnimation(animationStyle: .normal, revertAfterDelay: 0.0)
                }
                
                self.loginButton.isEnabled = true
                self.signUpButton.isEnabled = true
            }
        }).disposed(by: disposeBag)
    }
    
    private func createObservers() {
        self.viewModel.isSuccess.asObservable().bind { value in
        
            self.loginButton.isEnabled = true
            self.signUpButton.isEnabled = true
            
            if !value && self.loginButton.isLoading {
                self.loginButton.stopAnimation(animationStyle: .normal, revertAfterDelay: 0.0)
            }
            
            if self.signUpButton.isLoading {
                self.signUpButton.stopAnimation(animationStyle: .normal, revertAfterDelay: 0.0)
                
                self.emailTextField.rx.text.onNext("")
                self.viewModel.emailViewModel.data.accept("")
                self.passwordTextField.rx.text.onNext("")
                self.viewModel.passwordViewModel.data.accept("")
            }
        }.disposed(by: disposeBag)
        
        self.viewModel.isSignedIn.asObservable().bind { value in
            if value {
                self.loginButton.stopAnimation(animationStyle: .expand)
            }
        }.disposed(by: disposeBag)
        
        self.viewModel.errorMessage.asObservable().bind { value in
            showMessage(with: value)
        }.disposed(by: disposeBag)
    }
    
    internal func set(_ viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
}
