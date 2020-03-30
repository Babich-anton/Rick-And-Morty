//
//  EpisodeModel.swift
//  Rick And Morty
//
//  Created by Anton Babich on 20.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import Alamofire
import Foundation

struct Episode: Codable {
    
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
    
    static func get(by id: Int, completionHandler: @escaping ((Episode?, Error?) -> ())) {
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        AF.request(
            API.ENDPOINT + API.EPISODE + String(id),
            method: .get
        ).responseJSON { response in
            switch(response.result) {
            case .success(_):
                do {
                    let episode = try JSONDecoder().decode(Episode.self, from: response.data!)
                    completionHandler(episode, nil)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, episode, characters, url, created
        case airDate = "air_date"
    }
}
