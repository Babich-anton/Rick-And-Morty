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
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var logoutButton: UIButton!
    
    var viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        self.createViewModelBinding()
        self.createObservers()
    }
    
    private func createViewModelBinding() {
        
        self.emailTextField.rx.text.orEmpty
            .bind(to: viewModel.emailViewModel.data)
            .disposed(by: disposeBag)
        
        self.passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.passwordViewModel.data)
            .disposed(by: disposeBag)
        
        self.loginButton.rx.tap.do(onNext: { [unowned self] in
            self.emailTextField.resignFirstResponder()
            self.loginButton.resignFirstResponder()
        }).subscribe(onNext: { [unowned self] in
            if self.viewModel.validateCredentials() {
                self.viewModel.loginUser()
            }
        }).disposed(by: disposeBag)
        
        self.logoutButton.rx.tap.do(onNext: { [unowned self] in
            self.emailTextField.resignFirstResponder()
            self.loginButton.resignFirstResponder()
        }).subscribe(onNext: { [unowned self] in
            if self.viewModel.validateCredentials() {
                self.viewModel.signUp()
            }
        }).disposed(by: disposeBag)
    }
    
    private func createObservers() {
        
        self.viewModel.isSuccess.asObservable()
            .bind { value in
                print(value)
        }.disposed(by: disposeBag)
        
        self.viewModel.errorMessage.asObservable()
            .bind { value in
                print(value)
                showMessage(with: value)
        }.disposed(by: disposeBag)
    }
}
