//
//  CharactersModel.swift
//  Rick And Morty
//
//  Created by Anton Babich on 20.03.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import Foundation

struct Characters: Codable {
    
    let info: Info
    let results: [Character]
}
