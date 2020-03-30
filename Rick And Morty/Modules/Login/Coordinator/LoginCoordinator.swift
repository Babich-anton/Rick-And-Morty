//
//  LoginCoordinator.swift
//  Rick And Morty
//
//  Created by Anton Babich on 15.03.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class LoginCoordinator: CoordinatorProtocol {
    
    lazy var mainCoordinator = MainCoordinator()
    
    lazy var loginViewModel = LoginViewModel()
    
    private let disposeBag = DisposeBag()
    
    func start(from viewController: UIViewController) {
        
        if let loginViewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            
            loginViewController.modalPresentationStyle = .fullScreen
            loginViewController.viewModel = loginViewModel
            viewController.present(loginViewController, animated: true)
            
            loginViewModel.isSignedIn.asObservable().bind { value in
                if value {
                    self.coordinate(to: self.mainCoordinator, from: loginViewController)
                }
            }.disposed(by: disposeBag)
        }
    }
    
    func coordinate(to coordinator: CoordinatorProtocol, from viewController: UIViewController) {
        coordinator.start(from: viewController)
    }
}
