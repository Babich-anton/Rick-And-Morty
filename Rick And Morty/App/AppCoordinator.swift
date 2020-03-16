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
    
    func start(from viewController: UIViewController) -> Observable<Void> {
        viewController.rx.viewDidAppear.bind(onNext: { [unowned self] () in
            _ = self.coordinate(to: self.loginCoordinator, from: viewController)
        }).disposed(by: disposeBag)
        
        return Observable.never()
    }
    
    func coordinate(to coordinator: CoordinatorProtocol, from viewControoler: UIViewController) -> Observable<Void> {
        return coordinator.start(from: viewControoler)
    }
}
