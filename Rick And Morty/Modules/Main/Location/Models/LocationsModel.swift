//
//  LocationsModel.swift
//  Rick And Morty
//
//  Created by Anton Babich on 20.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import Alamofire
import Foundation

struct Locations: Codable {
    
    let info: Info
    let results: [Location]
    
    struct Info: Codable {
        
        let count: Int
        let pages: Int
        let next: String
        let prev: String
    }
    
    static func getLocations(from url: String?, completionHandler: @escaping ((Locations?, Error?) -> ())) {
        
        var endpoint = API.ENDPOINT + API.LOCATION
        
        if let url = url {
            endpoint = url
        }
        
        AF.request(
            endpoint,
            method: .get
        ).responseJSON { response in
            switch(response.result) {
            case .success(_):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let locations = try JSONDecoder().decode(Locations.self, from: response.data!)
                    completionHandler(locations, nil)
                } catch {
                    print(error.localizedDescription)
                    completionHandler(nil, error)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(nil, error)
            }
        }
    }
    
    static func search(by name: String, completionHandler: @escaping ((Locations?, Error?) -> ())) {
        
        let queryName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        AF.request(
            API.ENDPOINT + API.LOCATION + "?name=" + queryName,
            method: .get
        ).responseJSON { response in
            switch(response.result) {
            case .success(_):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let locations = try JSONDecoder().decode(Locations.self, from: response.data!)
                    completionHandler(locations, nil)
                } catch {
                    print(error.localizedDescription)
                    completionHandler(nil, nil)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(nil, error)
            }
        }
    }
}
