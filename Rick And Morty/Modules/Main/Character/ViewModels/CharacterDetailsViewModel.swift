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
    
    var character: BehaviorRelay<Character?> = BehaviorRelay<Character?>(value: nil)
    var isFailedLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    init(id: Int) {
        super.init()
        
        Character.get(by: id) { character, error in
            if let error = error {
                showMessage(with: error.localizedDescription)
                self.isFailedLoading.accept(true)
            } else if let character = character {
                self.character.accept(character)
            }
        }
    }
}
