//
//  CharacterViewModel.swift
//  Rick And Morty
//
//  Created by Anton Babich on 20.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import RxSwift
import RxCocoa

class CharacterViewModel: NSObject {
    
    private let disposeBag = DisposeBag()
    
    var characters: BehaviorRelay<[Character]> = BehaviorRelay<[Character]>(value: [])
    var nextPage: String? = nil
    
    override init() {
        super.init()
        
        self.loadNextPage(nil)
    }
    
    func loadNextPage(_ url: String?) {
        
        Characters.getCharacters(from: url) { characters, error in
            if let characters = characters {
                self.characters.accept(characters.results)
                self.nextPage = characters.info.next
            } else if let error = error {
                showMessage(with: error.localizedDescription)
            }
        }
    }
}
