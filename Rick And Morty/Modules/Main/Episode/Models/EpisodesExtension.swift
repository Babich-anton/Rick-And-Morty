//
//  EpisodesExtension.swift
//  Rick And Morty
//
//  Created by Anton Babich on 09.06.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import Alamofire

extension Episodes {
    
    static func getEpisodes(from url: String?, completionHandler: @escaping ((Episodes?, Error?) -> Void)) {
        
        var endpoint = API.ENDPOINT + API.EPISODE
        
        if let url = url {
            endpoint = url
        }
        
        AF.request(
            endpoint,
            method: .get
        ).responseJSON { response in
            switch response.result {
            case .success:
                do {
                    guard let data = response.data else {
                        return
                    }
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let episodes = try JSONDecoder().decode(Episodes.self, from: data)
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
    
    static func search(by name: String, completionHandler: @escaping ((Episodes?, Error?) -> Void)) {
        
        let queryName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        AF.request(
            API.ENDPOINT + API.EPISODE + "?name=" + queryName,
            method: .get
        ).responseJSON { response in
            switch response.result {
            case .success:
                do {
                    guard let data = response.data else {
                        return
                    }
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let episodes = try JSONDecoder().decode(Episodes.self, from: data)
                    completionHandler(episodes, nil)
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
