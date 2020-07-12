//
//  UserViewModel.swift
//  Rick And Morty
//
//  Created by Anton Babich on 27.03.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import FirebaseAuth
import RxCocoa
import RxSwift

class ProfileViewModel: NSObject, ViewModel {
    
    private var handle: AuthStateDidChangeListenerHandle?
    
    private var user: BehaviorRelay<User?> = BehaviorRelay<User?>(value: nil)
    
    private let disposeBag = DisposeBag()
    
    let nameViewModel = NameViewModel()
    let emailViewModel = ProfileEmailViewModel()
    let newPasswordViewModel = ProfilePasswordViewModel()
    let confirmPasswordViewModel = ProfilePasswordViewModel()
    
    private let isImageUpdated: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    private let isUpdated: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    private let errorMessage: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    
    weak var delegate: ProfileViewProtocol?
    
    override init() {
        super.init()
        
        self.handle = Auth.auth().addStateDidChangeListener { (_, user) in
            if let user = user {
                self.user.accept(user)
            } else {
                self.user.accept(nil)
            }
        }
    }
    
    func setupBinding() {
        user.subscribe(onNext: { [weak self] user in
            if let user = user {
                self?.delegate?.set(user: user)
            }
        }).disposed(by: disposeBag)
        
        isUpdated.subscribe(onNext: { [weak self] value in
            self?.delegate?.set(value: value)
        }).disposed(by: disposeBag)
    }
    
    func update() {
        if isValid() {
            let group = DispatchGroup()
            
            updateUsername(group)
            updateEmail(group)
            updatePassword(group)
            
            group.notify(queue: .main) {
                showMessage(with: self.errorMessage.value.isEmpty ? "User successfully updated" : self.errorMessage.value)
                self.isUpdated.accept(true)
            }
            
            self.errorMessage.accept("")
        } else {
            var message = ""
            
            if !nameViewModel.errorValue.value.isEmpty {
                message = nameViewModel.errorValue.value
            } else if !emailViewModel.errorValue.value.isEmpty {
                message = emailViewModel.errorValue.value
            } else if !newPasswordViewModel.errorValue.value.isEmpty {
                message = newPasswordViewModel.errorValue.value
            } else if !confirmPasswordViewModel.errorValue.value.isEmpty {
                message = confirmPasswordViewModel.errorValue.value
            }
            
            showMessage(with: message)
            isUpdated.accept(true)
        }
    }
    
    private func updateUsername(_ group: DispatchGroup) {
        if user.value?.displayName != nameViewModel.data.value {
            group.enter()
            isUpdated.accept(false)
            
            FirebaseManager.update(name: nameViewModel.data.value, successHandler: {
                group.leave()
            }, errorHandler: { error in
                self.errorMessage.accept(error.localizedDescription)
                group.leave()
            })
        }
    }
    
    private func updateEmail(_ group: DispatchGroup) {
        if user.value?.email != emailViewModel.data.value {
            group.enter()
            isUpdated.accept(false)
            
            if let user = user.value {
                FirebaseManager.update(email: emailViewModel.data.value, user: user, successHandler: {
                    group.leave()
                }, errorHandler: { error in
                    self.errorMessage.accept(error.localizedDescription)
                })
            }
        }
    }
    
    private func updatePassword(_ group: DispatchGroup) {
        if newPasswordViewModel.data.value == confirmPasswordViewModel.data.value && !confirmPasswordViewModel.data.value.isEmpty {
            
            group.enter()
            isUpdated.accept(false)
            
            if let user = user.value {
                FirebaseManager.update(email: confirmPasswordViewModel.data.value, user: user, successHandler: {
                    group.leave()
                }, errorHandler: { error in
                    self.errorMessage.accept(error.localizedDescription)
                })
            }
        }
    }
    
    private func isValid() -> Bool {
        return nameViewModel.validateCredentials() &&
            emailViewModel.validateCredentials() &&
            newPasswordViewModel.validateCredentials() &&
            confirmPasswordViewModel.validateCredentials()
    }
    
    func getDisposeBag() -> DisposeBag {
        return self.disposeBag
    }
    
    deinit {
        if let handle = self.handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
