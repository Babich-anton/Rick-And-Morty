//
//  CharacterModel.swift
//  Rick And Morty
//
//  Created by Anton Babich on 20.03.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import Foundation

struct Character: Codable {
    
    struct Planet: Codable {
        let name: String
        let url: String
    }
    
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: Planet
    let location: Planet
    let image: String
    let episode: [String]
    let url: String
    let created: String
}
