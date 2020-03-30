//
//  LoginModel.swift
//  Rick And Morty
//
//  Created by Anton Babich on 15.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import Foundation

class LoginModel {
    
    var email = ""
    var password = ""
    
    convenience init(email: String, password: String) {
        
        self.init()
        self.email    = email
        self.password = password
    }
}
