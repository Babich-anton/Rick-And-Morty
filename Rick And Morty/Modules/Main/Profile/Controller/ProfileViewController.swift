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
    
    private var viewModel: ProfileViewModel! // swiftlint:disable:this implicitly_unwrapped_optional
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet internal weak var imageView: UIImageView!
    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var newPasswordField: UITextField!
    @IBOutlet private weak var confirmPasswordField: UITextField!
    @IBOutlet private weak var saveButton: TransitionButton!
    @IBOutlet private weak var logoutButton: TransitionButton!
    @IBOutlet internal weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var imageViewTapper: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = imageView.bounds.midY
        imageView.clipsToBounds = true
        imageView.setNeedsDisplay()
        
        setupBinding()
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
        self.viewModel.delegate = self
        self.viewModel.setupBinding()
        self.setupButtonBinding()
        
        self.nameField.rx.text.orEmpty
            .bind(to: viewModel.nameViewModel.data)
            .disposed(by: viewModel.getDisposeBag())
        self.emailField.rx.text.orEmpty
            .bind(to: viewModel.emailViewModel.data)
            .disposed(by: viewModel.getDisposeBag())
        self.newPasswordField.rx.text.orEmpty
            .bind(to: viewModel.newPasswordViewModel.data)
            .disposed(by: viewModel.getDisposeBag())
        self.confirmPasswordField.rx.text.orEmpty
            .bind(to: viewModel.confirmPasswordViewModel.data)
            .disposed(by: viewModel.getDisposeBag())
    }
    
    private func setupButtonBinding() {
        self.bindSaveButton()
        self.bindLogoutButton()
        
        self.imageViewTapper.rx.event.bind(onNext: { _ in
            self.changeUserImage()
        }).disposed(by: viewModel.getDisposeBag())
    }
    
    private func bindSaveButton() {
        self.saveButton.rx.tap.do(onNext: { [weak self] in
            self?.saveButton.startAnimation()
        }).subscribe(onNext: { [weak self] in
            self?.viewModel.update()
        }).disposed(by: viewModel.getDisposeBag())
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
        }).disposed(by: viewModel.getDisposeBag())
    }
    
    func set(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }
    
    deinit {
        print("deinit ProfileViewController")
    }
}

extension ProfileViewController: ProfileViewProtocol {
    
    func set(user: User) {
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
    }
    
    func set(value: Bool) {
        if self.saveButton.isLoading && value {
            self.saveButton.stopAnimation(animationStyle: .normal, revertAfterDelay: 0.0)
            
            self.newPasswordField.rx.text.onNext("")
            self.viewModel.newPasswordViewModel.data.accept("")
            self.confirmPasswordField.rx.text.onNext("")
            self.viewModel.confirmPasswordViewModel.data.accept("")
        }
    }
}
