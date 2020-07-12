//
//  ProfileViewController.swift
//  Rick And Morty
//
//  Created by Anton Babich on 19.03.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import Foundation
import FirebaseAuth
import RxCocoa
import RxSwift
import UIKit

class ProfileViewController: UIViewController {
    
    var viewModel: ProfileViewModel! // swiftlint:disable:this implicitly_unwrapped_optional
    
    private let disposeBag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var saveButton: TransitionButton!
    @IBOutlet weak var logoutButton: TransitionButton!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var imageViewTapper: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = imageView.bounds.midY
        imageView.clipsToBounds = true
        imageView.setNeedsDisplay()
        
        setupBinding()
        setupButtonBinding()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.newPasswordField.rx.text.onNext("")
        self.viewModel.newPasswordViewModel.data.accept("")
        self.confirmPasswordField.rx.text.onNext("")
        self.viewModel.confirmPasswordViewModel.data.accept("")
    }
    
    private func setupBinding() {
        
        self.viewModel.user.subscribe(onNext: { [weak self] user in
            guard let `self` = self, let user = user else {
                return
            }
            
            if let url = user.photoURL {
                self.imageView.af.setImage(withURL: url) { _ in
                    self.imageView.isHidden = false
                    self.indicatorView.stopAnimating()
                }
            } else {
                self.imageView.isHidden = false
                self.indicatorView.stopAnimating()
            }
            
            self.nameField.text = user.displayName
            self.emailField.text = user.email
        }).disposed(by: disposeBag)
        
        self.viewModel.isUpdated.subscribe(onNext: { [weak self] value in
            guard let `self` = self else {
                return
            }
            
            if self.saveButton.isLoading && value {
                self.saveButton.stopAnimation(animationStyle: .normal, revertAfterDelay: 0.0)
                
                self.newPasswordField.rx.text.onNext("")
                self.viewModel.newPasswordViewModel.data.accept("")
                self.confirmPasswordField.rx.text.onNext("")
                self.viewModel.confirmPasswordViewModel.data.accept("")
            }
        }).disposed(by: disposeBag)
        
        self.nameField.rx.text.orEmpty
            .bind(to: viewModel.nameViewModel.data)
            .disposed(by: disposeBag)
        self.emailField.rx.text.orEmpty
            .bind(to: viewModel.emailViewModel.data)
            .disposed(by: disposeBag)
        self.newPasswordField.rx.text.orEmpty
            .bind(to: viewModel.newPasswordViewModel.data)
            .disposed(by: disposeBag)
        self.confirmPasswordField.rx.text.orEmpty
            .bind(to: viewModel.confirmPasswordViewModel.data)
            .disposed(by: disposeBag)
    }
    
    private func setupButtonBinding() {
        self.bindSaveButton()
        self.bindLogoutButton()
        
        self.imageViewTapper.rx.event.bind(onNext: { _ in
            self.changeUserImage()
        }).disposed(by: disposeBag)
    }
    
    private func bindSaveButton() {
        self.saveButton.rx.tap.do(onNext: { [weak self] in
            self?.saveButton.startAnimation()
        }).subscribe(onNext: { [weak self] in
            self?.viewModel.update()
        }).disposed(by: disposeBag)
    }
    
    private func bindLogoutButton() {
        self.logoutButton.rx.tap.do(onNext: { [weak self] in
            self?.logoutButton.startAnimation()
        }).subscribe(onNext: { [weak self] in
            guard let `self` = self else {
                return
            }
            
            do {
                try Auth.auth().signOut()
            } catch {
                showMessage(with: error.localizedDescription)
            }
            
            self.logoutButton.stopAnimation(animationStyle: .expand) {
                self.dismiss(animated: false)
            }
        }).disposed(by: disposeBag)
    }
    
    deinit {
        print("deinit ProfileViewController")
    }
}
