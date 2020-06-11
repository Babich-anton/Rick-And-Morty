//
//  ScopeButtons.swift
//  Rick And Morty
//
//  Created by Anton Babich on 11.06.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import Foundation

enum CharacterStatus: String {
    
    case all = "All"
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "Unknown"
}

extension Array where Element == CharacterStatus {
    
    func getTitles() -> [String] {
        var titles = [String]()
        
        for title in self {
            titles.append(title.rawValue)
        }
        
        return titles
    }
}
