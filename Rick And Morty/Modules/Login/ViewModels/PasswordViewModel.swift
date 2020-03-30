//
//  PasswordViewModel.swift
//  Rick And Morty
//
//  Created by Anton Babich on 15.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import Foundation
import RxCocoa

class PasswordViewModel: ValidationViewModelProtocol {
    
    var data: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    
    var errorMessage: String = "Please enter a valid password. Minimum password length: 6. Maximum password length: 15."
    
    var errorValue: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    
    func validateCredentials() -> Bool {
        
        guard validateLength(text: data.value, size: (6, 15)) else {
            errorValue.accept(errorMessage)
            
            return false
        }
        
        errorValue.accept("")
        
        return true
    }
    
    func validateLength(text: String, size: (min: Int, max: Int)) -> Bool {
        return (size.min...size.max).contains(text.count)
    }
}
