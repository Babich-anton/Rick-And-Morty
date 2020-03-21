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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
            
        }).subscribe(onNext: { [unowned self] in
            
            if self.viewModel.validateCredentials() {
                self.viewModel.loginUser()
            } else {
                if let text = self.viewModel.emailViewModel.errorValue.value, !text.isEmpty {
                    
                    showMessage(with: text)
                    self.loginButton.stopAnimation()
                    self.passwordTextField.text = ""
                    
                } else if let text = self.viewModel.passwordViewModel.errorValue.value, !text.isEmpty {
                    
                    showMessage(with: text)
                    self.loginButton.stopAnimation()
                    self.passwordTextField.text = ""
                    
                }
            }
            
        }).disposed(by: disposeBag)
        
        self.signUpButton.rx.tap.do(onNext: { [unowned self] in
            
            self.signUpButton.startAnimation()
            
        }).subscribe(onNext: { [unowned self] in
            
            if self.viewModel.validateCredentials() {
                self.viewModel.signUp()
            } else {
               if let text = self.viewModel.emailViewModel.errorValue.value, !text.isEmpty {
                   showMessage(with: text)
                   self.signUpButton.stopAnimation()
               } else if let text = self.viewModel.passwordViewModel.errorValue.value, !text.isEmpty {
                   showMessage(with: text)
                   self.signUpButton.stopAnimation()
               }
           }
            
        }).disposed(by: disposeBag)
    }
    
    private func createObservers() {
        
        self.viewModel.isSuccess.asObservable().bind { value in
            
            if !value && self.loginButton.isLoading {
                self.loginButton.stopAnimation()
            }
            
            if self.signUpButton.isLoading {
                self.signUpButton.stopAnimation()
                
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
            }
        }.disposed(by: disposeBag)
        
        self.viewModel.errorMessage.asObservable().bind { value in
            showMessage(with: value)
        }.disposed(by: disposeBag)
    }
}