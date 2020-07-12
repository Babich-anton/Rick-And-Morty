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
        self.setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.viewModel.isSignedIn.accept(false)
        self.emailTextField.rx.text.onNext("anton.babich@sqil.by")
        self.viewModel.emailViewModel.data.accept("anton.babich@sqil.by")
        self.passwordTextField.rx.text.onNext("barmaley98")
        self.viewModel.passwordViewModel.data.accept("barmaley98")
    }
    
    private func setupBinding() {
        self.bindFields()
        self.bindButtons()
    }
    
    private func bindFields() {
        self.emailTextField.rx.text.orEmpty
            .bind(to: viewModel.emailViewModel.data)
            .disposed(by: viewModel.getDisposeBag())

        self.passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.passwordViewModel.data)
            .disposed(by: viewModel.getDisposeBag())
    }
    
    private func bindButtons() {
        self.viewModel.bind(loginButton: self.loginButton)
        self.viewModel.bind(signUpButton: self.signUpButton)
        self.viewModel.delegate = self
    }
    
    private func clearForm() {
        self.clearLogin()
        self.clearPassword()
    }
    
    private func clearLogin() {
        self.emailTextField.rx.text.onNext("")
        self.viewModel.emailViewModel.data.accept("")
    }
    
    private func clearPassword() {
        self.passwordTextField.rx.text.onNext("")
        self.viewModel.passwordViewModel.data.accept("")
    }
    
    internal func set(_ viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
}

extension LoginViewController: LoginViewProtocol {
    
    func loginTapped() {
        self.loginButton.startAnimation()
        self.loginButton.isEnabled = false
        self.signUpButton.isEnabled = false
    }
    
    func loginSuccess() {
        self.clearForm()
        self.loginButton.stopAnimation(animationStyle: .normal, revertAfterDelay: 0.0)
        self.loginButton.isEnabled = true
        self.signUpButton.isEnabled = true
    }
    
    func loginFailed() {
        self.clearPassword()
        self.loginButton.stopAnimation(animationStyle: .normal, revertAfterDelay: 0.0)
        self.loginButton.isEnabled = true
        self.signUpButton.isEnabled = true
    }
    
    func signUpTapped() {
        self.signUpButton.startAnimation()
        self.loginButton.isEnabled = false
        self.signUpButton.isEnabled = false
    }
    
    func signUpSuccess() {
        self.clearPassword()
        self.signUpButton.stopAnimation(animationStyle: .normal, revertAfterDelay: 0.0)
        self.loginButton.isEnabled = true
        self.signUpButton.isEnabled = true
        showMessage(with: "New user created successfully. Please sign in to the app.")
    }
    
    func signUpFailed() {
        self.clearPassword()
        self.signUpButton.stopAnimation(animationStyle: .normal, revertAfterDelay: 0.0)
        self.loginButton.isEnabled = true
        self.signUpButton.isEnabled = true
    }
    
    func show(errorMessage: String) {
        showMessage(with: errorMessage)
    }
}
