//
//  ValidationViewModelProtocol.swift
//  Rick And Morty
//
//  Created by Anton Babich on 15.03.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import Foundation
import RxCocoa

protocol ValidationViewModelProtocol {
    
    var data: BehaviorRelay<String> { get set }
    
    var errorMessage: String { get }
    var errorValue: BehaviorRelay<String> { get }
    
    func validateCredentials() -> Bool
}
