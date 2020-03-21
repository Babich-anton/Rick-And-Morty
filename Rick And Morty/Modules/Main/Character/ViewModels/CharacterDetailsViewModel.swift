//
//  CharacterDetailsViewModel.swift
//  Rick And Morty
//
//  Created by Anton Babich on 21.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import RxSwift
import RxCocoa

class CharacterDetailsViewModel: NSObject {
    
    private let disposeBag = DisposeBag()
    
    var character: BehaviorRelay<Character>!
    
    init(character: Character) {
        super.init()
        
        self.character = BehaviorRelay<Character>(value: character)
    }
}
