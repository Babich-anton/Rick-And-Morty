//
//  CharactersModel.swift
//  Rick And Morty
//
//  Created by Anton Babich on 20.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import Alamofire
import Foundation

struct Characters: Codable {
    
    let info: Info
    let results: [Character]
    
    struct Info: Codable {
        
        let count: Int
        let pages: Int
        let next: String
        let prev: String
    }
    
    static func getCharacters(from url: String?, completionHandler: @escaping ((Characters?, Error?) -> ())) {
        
        var endpoint = API.ENDPOINT + API.CHARACTER
        
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
                    
                    let characters = try JSONDecoder().decode(Characters.self, from: response.data!)
                    completionHandler(characters, nil)
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
    
    static func search(by name: String, status: String, completionHandler: @escaping ((Characters?, Error?) -> ())) {
        
        let statusUrl = status == "All" ? "" : "&status=" + status.lowercased()
        let queryName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let queryStatus = statusUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        AF.request(
            API.ENDPOINT + API.CHARACTER + "?name=" + queryName + queryStatus,
            method: .get
        ).responseJSON { response in
            switch(response.result) {
            case .success(_):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let characters = try JSONDecoder().decode(Characters.self, from: response.data!)
                    completionHandler(characters, nil)
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
