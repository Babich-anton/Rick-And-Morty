//
//  AppCoordinator.swift
//  Rick And Morty
//
//  Created by Anton Babich on 15.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class AppCoordinator: CoordinatorProtocol {
    
    lazy var loginCoordinator = LoginCoordinator()
    
    private let disposeBag = DisposeBag()
    
    func start(from viewController: UIViewController) {
        viewController.rx.viewDidAppear.subscribe(onNext: {
            self.coordinate(to: self.loginCoordinator, from: viewController)
        }).disposed(by: disposeBag)
    }
    
    func coordinate(to coordinator: CoordinatorProtocol, from viewController: UIViewController) {
        return coordinator.start(from: viewController)
    }
}
