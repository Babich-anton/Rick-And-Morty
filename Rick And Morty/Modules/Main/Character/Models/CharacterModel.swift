//
//  CharacterModel.swift
//  Rick And Morty
//
//  Created by Anton Babich on 20.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import Foundation
import Alamofire

struct Character: Codable {
    
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: Planet
    let location: Planet
    let image: String
    let episode: [String]
    let url: String
    let created: String
    
    struct Planet: Codable {
        
        let name: String
        let url: String
    }
    
    static func getCharacter(_ id: Int, completionHandler: @escaping ((Character?, Error?) -> ())) {
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        AF.request(
            API.ENDPOINT + API.CHARACTER + String(id),
            method: .get
        ).responseJSON { response in
            switch(response.result) {
            case .success(_):
                do {
                    let character = try JSONDecoder().decode(Character.self, from: response.data!)
                    completionHandler(character, nil)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
