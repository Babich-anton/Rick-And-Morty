//
//  Info.swift
//  Rick And Morty
//
//  Created by Anton Babich on 10.06.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import Foundation

struct Info: Codable {
    
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
