//
//  LoginViewController.swift
//  Rick And Morty
//
//  Created by Anton Babich on 15.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: TransitionButton!
    @IBOutlet var signUpButton: TransitionButton!
    
    var viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        self.createViewModelBinding()
        self.createObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    
    private func createViewModelBinding() {
        
        self.emailTextField.rx.text.orEmpty
            .bind(to: viewModel.emailViewModel.data)
            .disposed(by: disposeBag)

        self.passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.passwordViewModel.data)
            .disposed(by: disposeBag)
        
        self.loginButton.rx.tap.do(onNext: { [unowned self] in
            
            self.loginButton.startAnimation()
            self.loginButton.isEnabled = false
            self.signUpButton.isEnabled = false
            
        }).subscribe(onNext: { [unowned self] in
            
            if self.viewModel.validateCredentials() {
                self.viewModel.loginUser()
            } else {
                if !self.viewModel.emailViewModel.errorValue.value.isEmpty {
                    
                    showMessage(with: self.viewModel.emailViewModel.errorValue.value)
                    self.loginButton.stopAnimation(animationStyle: .normal, revertAfterDelay: 0.0)
                    self.passwordTextField.text = ""
                    
                } else if !self.viewModel.passwordViewModel.errorValue.value.isEmpty {
                    
                    showMessage(with: self.viewModel.passwordViewModel.errorValue.value)
                    self.loginButton.stopAnimation(animationStyle: .normal, revertAfterDelay: 0.0)
                    self.passwordTextField.text = ""
                }
                
                self.loginButton.isEnabled = true
                self.signUpButton.isEnabled = true
            }
            
        }).disposed(by: disposeBag)
        
        self.signUpButton.rx.tap.do(onNext: { [unowned self] in
            
            self.signUpButton.startAnimation()
            self.loginButton.isEnabled = false
            self.signUpButton.isEnabled = false
            
        }).subscribe(onNext: { [unowned self] in
            
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
                
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
