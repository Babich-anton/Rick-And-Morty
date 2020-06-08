//
//  CharacterExtension.swift
//  Rick And Morty
//
//  Created by Anton Babich on 09.06.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import Alamofire

extension Character {
    // todo: add success and error completion handler
    
    static func get(by id: Int, completionHandler: @escaping ((Character?, Error?) -> Void)) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        AF.request(
            API.ENDPOINT + API.CHARACTER + String(id),
            method: .get
        ).responseJSON { response in
            switch response.result {
            case .success:
                do {
                    guard let data = response.data else {
                        return
                    }
                    
                    let character = try JSONDecoder().decode(Character.self, from: data)
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
