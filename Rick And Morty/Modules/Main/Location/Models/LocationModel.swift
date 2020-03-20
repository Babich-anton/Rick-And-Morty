//
//  LocationModel.swift
//  Rick And Morty
//
//  Created by Anton Babich on 20.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import Foundation
import Alamofire

struct Location: Codable {
    
    let id: String
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String
    
    static func getLocation(_ id: Int, completionHandler: @escaping ((Location?, Error?) -> ())) {
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        AF.request(
            API.ENDPOINT + API.CHARACTER + String(id),
            method: .get
        ).responseJSON { response in
            switch(response.result) {
            case .success(_):
                do {
                    let location = try JSONDecoder().decode(Location.self, from: response.data!)
                    completionHandler(location, nil)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
