//
//  CoordinatorProtocol.swift
//  Rick And Morty
//
//  Created by Anton Babich on 15.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

protocol CoordinatorProtocol {
    
    func start(from viewController: UIViewController) -> Observable<Void>
    func coordinate(to coordinator: CoordinatorProtocol,
                    from viewControoler: UIViewController) -> Observable<Void>
}
