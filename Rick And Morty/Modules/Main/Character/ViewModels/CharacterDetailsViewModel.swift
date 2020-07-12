//
//  CharacterDetailsViewModel.swift
//  Rick And Morty
//
//  Created by Anton Babich on 21.03.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import RxSwift
import RxCocoa

class CharacterDetailsViewModel: NSObject {
    
    private var character: BehaviorRelay<Character?> = BehaviorRelay<Character?>(value: nil)
    private var isFailedLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    private let disposeBag = DisposeBag()
    
    weak var detailsDelegate: CharacterDetailsViewProtocol?
    
    init(id: Int) {
        super.init()
        
        Character.get(by: id, successHandler: { character in
            self.character.accept(character)
        }, errorHandler: { error in
            showMessage(with: error.localizedDescription)
            self.isFailedLoading.accept(true)
        })
    }
    
    func setupBinding() {
        character.subscribe(onNext: { [weak self] character in
            if let character = character {
                self?.detailsDelegate?.set(character: character)
            }
        }).disposed(by: disposeBag)
        
        isFailedLoading.subscribe(onNext: { [weak self] value in
            self?.detailsDelegate?.set(loadingFailed: value)
        }).disposed(by: disposeBag)
    }
}
