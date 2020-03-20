//
//  LocationsModel.swift
//  Rick And Morty
//
//  Created by Anton Babich on 20.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import Foundation
import Alamofire

struct Locations: Codable {
    
    let info: Info
    let results: [Location]
    
    struct Info: Codable {
        
        let count: Int
        let pages: Int
        let next: String
        let prev: String
    }
    
    static func getLocations(completionHandler: @escaping ((Locations?, Error?) -> ())) {
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        AF.request(
            API.ENDPOINT + API.LOCATION,
            method: .get
        ).responseJSON { response in
            switch(response.result) {
            case .success(_):
                do {
                    let locations = try JSONDecoder().decode(Locations.self, from: response.data!)
                    completionHandler(locations, nil)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
