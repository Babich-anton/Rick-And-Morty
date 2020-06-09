//
//  CharactersExtension.swift
//  Rick And Morty
//
//  Created by Anton Babich on 09.06.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import Alamofire

extension Characters {
    
    static func getCharacters(from url: String?,
                              successHandler: @escaping ((Characters) -> Void),
                              errorHandler: @escaping ((Error) -> Void)) {
        
        var endpoint = API.ENDPOINT + API.CHARACTER
        
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
                    
                    let characters = try JSONDecoder().decode(Characters.self, from: data)
                    successHandler(characters)
                } catch {
                    errorHandler(error)
                }
            case .failure(let error):
                errorHandler(error)
            }
        }
    }
    
    static func search(by name: String,
                       status: String,
                       successHandler: @escaping ((Characters) -> Void),
                       errorHandler: @escaping ((Error) -> Void)) {
        
        let statusUrl = status == "All" ? "" : "&status=" + status.lowercased()
        let queryName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let queryStatus = statusUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        AF.request(
            API.ENDPOINT + API.CHARACTER + "?name=" + queryName + queryStatus,
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
                    
                    let characters = try JSONDecoder().decode(Characters.self, from: data)
                    successHandler(characters)
                } catch {
                    errorHandler(error)
                }
            case .failure(let error):
                errorHandler(error)
            }
        }
    }
}
