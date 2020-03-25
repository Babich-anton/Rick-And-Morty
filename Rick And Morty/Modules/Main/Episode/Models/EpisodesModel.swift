//
//  EpisodesModel.swift
//  Rick And Morty
//
//  Created by Anton Babich on 20.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import Alamofire
import Foundation

struct Episodes: Codable {
    
    let info: Info
    let results: [Episode]
    
    struct Info: Codable {
        
        let count: Int
        let pages: Int
        let next: String
        let prev: String
    }
    
    static func getEpisodes(from url: String?, completionHandler: @escaping ((Episodes?, Error?) -> ())) {
        
        var endpoint = API.ENDPOINT + API.EPISODE
        
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
                    
                    let episodes = try JSONDecoder().decode(Episodes.self, from: response.data!)
                    completionHandler(episodes, nil)
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
    
    static func search(by name: String, completionHandler: @escaping ((Episodes?, Error?) -> ())) {
        
        let queryName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        AF.request(
            API.ENDPOINT + API.EPISODE + "?name=" + queryName,
            method: .get
        ).responseJSON { response in
            switch(response.result) {
            case .success(_):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let episodes = try JSONDecoder().decode(Episodes.self, from: response.data!)
                    completionHandler(episodes, nil)
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
}
