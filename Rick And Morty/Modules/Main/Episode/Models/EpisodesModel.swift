//
//  EpisodesModel.swift
//  Rick And Morty
//
//  Created by Anton Babich on 20.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import Foundation
import Alamofire

struct Episodes: Codable {
    
    let info: Info
    let results: [Episode]
    
    struct Info: Codable {
        
        let count: Int
        let pages: Int
        let next: String
        let prev: String
    }
    
    static func get(completionHandler: @escaping ((Episodes?, Error?) -> ())) {
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        AF.request(
            API.ENDPOINT + API.EPISODE,
            method: .get
        ).responseJSON { response in
            switch(response.result) {
            case .success(_):
                do {
                    let episodes = try JSONDecoder().decode(Episodes.self, from: response.data!)
                    completionHandler(episodes, nil)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
