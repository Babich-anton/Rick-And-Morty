//
//  EmailViewModel.swift
//  Rick And Morty
//
//  Created by Anton Babich on 15.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import Foundation
import RxCocoa

class EmailViewModel: ValidationViewModelProtocol {
    
    var data: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    
    var errorMessage: String = "Please enter a valid email"
    
    var errorValue: BehaviorRelay<String?> = BehaviorRelay<String?>(value: "")
    
    func validateCredentials() -> Bool {
        
        guard validatePattern(text: data.value) else {
            errorValue.accept(errorMessage)
            
            return false
        }
        
        errorValue.accept("")
        
        return true
    }
    
    func validatePattern(text: String) -> Bool {
        
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let email = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return email.evaluate(with: text)
    }
}
