//
//  ProfileViewController.swift
//  Rick And Morty
//
//  Created by Anton Babich on 19.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import FirebaseAuth
import RxCocoa
import RxSwift
import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var saveButton: TransitionButton!
    @IBOutlet weak var logoutButton: TransitionButton!
    
    var viewModel: ProfileViewModel!
    
    private let disposeBag = DisposeBag()
    
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
        
        self.viewModel.user.subscribe(onNext: { [unowned self] user in
            if let url = user?.photoURL {
                self.imageView.af.setImage(withURL: url)
            }
            
            self.nameField.text = user?.displayName
            self.emailField.text = user?.email
        }).disposed(by: disposeBag)
        
        self.viewModel.isUpdated.subscribe(onNext: { [unowned self] value in
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
        
        self.saveButton.rx.tap.do(onNext: { [unowned self] in
            self.saveButton.startAnimation()
        }).subscribe(onNext: {[unowned self] in
            self.viewModel.update()
        }).disposed(by: disposeBag)
        
        self.logoutButton.rx.tap.do(onNext: { [unowned self] in
            self.logoutButton.startAnimation()
        }).subscribe(onNext: { [unowned self] in
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
