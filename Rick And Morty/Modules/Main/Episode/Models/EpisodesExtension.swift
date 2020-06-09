//
//  EpisodesExtension.swift
//  Rick And Morty
//
//  Created by Anton Babich on 09.06.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import Alamofire

extension Episodes {
    
    static func getEpisodes(from url: String?,
                            successHandler: @escaping ((Episodes) -> Void),
                            errorHandler: @escaping ((Error) -> Void)) {
        
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
                    successHandler(episodes)
                } catch {
                    errorHandler(error)
                }
            case .failure(let error):
                errorHandler(error)
            }
        }
    }
    
    static func search(by name: String,
                       successHandler: @escaping ((Episodes) -> Void),
                       errorHandler: @escaping ((Error) -> Void)) {
        
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
                    successHandler(episodes)
                } catch {
                    errorHandler(error)
                }
            case .failure(let error):
                errorHandler(error)
            }
        }
    }
}
