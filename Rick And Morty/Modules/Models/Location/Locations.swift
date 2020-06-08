//
//  LocationsModel.swift
//  Rick And Morty
//
//  Created by Anton Babich on 20.03.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import Alamofire
import Foundation

struct Locations: Codable {
    // todo:: table view create in class or add on storyboard
    // todo:: delete table view reference
    struct Info: Codable {
        
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: Info
    let results: [Location]
}
