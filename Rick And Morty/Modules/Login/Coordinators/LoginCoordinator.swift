//
//  LoginCoordinator.swift
//  Rick And Morty
//
//  Created by Anton Babich on 15.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class LoginCoordinator: CoordinatorProtocol {
    
    lazy var loginViewModel = LoginViewModel()
    var loginViewController: LoginViewController?
    
    private let disposeBag = DisposeBag()
    
    func start(from viewController: UIViewController) -> Observable<Void> {
        
        let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginViewController") as? LoginViewController
        loginViewController?.viewModel = loginViewModel
        
        if let vc = loginViewController {
            viewController.present(vc, animated: true)
        }
        
        return Observable.never()
    }
    
    func coordinate(to coordinator: CoordinatorProtocol,
                    from viewControoler: UIViewController) -> Observable<Void> {
        return coordinator.start(from: viewControoler)
    }
}
