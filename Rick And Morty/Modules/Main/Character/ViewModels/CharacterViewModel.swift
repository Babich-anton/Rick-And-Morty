//
//  CharacterViewModel.swift
//  Rick And Morty
//
//  Created by Anton Babich on 20.03.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import RxSwift
import RxCocoa

class CharacterViewModel: NSObject {
    
    private let disposeBag = DisposeBag()
    
    var characters: BehaviorRelay<[Character]> = BehaviorRelay<[Character]>(value: [])
    var nextPage: String?
    
    override init() {
        super.init()
        
        self.loadNextPage(nil)
    }
    
    func loadNextPage(_ url: String?) {
        Characters.getCharacters(from: url, successHandler: { ch in
            self.nextPage = ch.info.next
            var characters = self.characters.value
            
            for character in ch.results {
                if !characters.contains(where: { $0.id == character.id }) {
                    characters.append(character)
                }
            }
            
            self.characters.accept(characters)
        }, errorHandler: { error in
            showMessage(with: error.localizedDescription)
        })
    }
    
    func search(_ query: String, status: String) {
        Characters.search(by: query, status: status, successHandler: { characters in
            self.characters.accept(characters.results)
            self.nextPage = characters.info.next
        }, errorHandler: { error in
            showMessage(with: error.localizedDescription)
        })
    }
}
