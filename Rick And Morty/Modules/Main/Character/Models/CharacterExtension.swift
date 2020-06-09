//
//  CharacterExtension.swift
//  Rick And Morty
//
//  Created by Anton Babich on 09.06.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import Alamofire

extension Character {
    
    static func get(by id: Int,
                    successHandler: @escaping ((Character) -> Void),
                    errorHandler: @escaping ((Error) -> Void)) {
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
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let character = try JSONDecoder().decode(Character.self, from: data)
                    successHandler(character)
                } catch {
                    errorHandler(error)
                }
            case .failure(let error):
                errorHandler(error)
            }
        }
    }
}
