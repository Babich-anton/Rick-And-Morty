//
//  ViewModelDelegate.swift
//  Rick And Morty
//
//  Created by Anton Babich on 12.07.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import RxSwift

protocol ViewModel: class {
    
    func getDisposeBag() -> DisposeBag
}

// MARK: - View model protocols

protocol CharacterViewModelProtocol: class {
    
    func loadNextPage(_ url: String?)
    
    func search(_ query: String, status: String)
}

protocol LocationViewModelProtocol: class {
    
    func loadNextPage(_ url: String?)
    
    func search(_ query: String)
}

protocol EpisodeViewModelProtocol: class {
    
    func loadNextPage(_ url: String?)
    
    func search(_ query: String)
}

// MARK: - Detail view controller protocols

protocol CharacterDetailsViewProtocol: class {
    
    func set(character: Character)
    
    func set(loadingFailed: Bool)
}

protocol LocationDetailsViewProtocol: class {
    
    func set(location: Location)
    
    func set(loadingFailed: Bool)
}

protocol EpisodeDetailsViewProtocol: class {
    
    func set(episode: Episode)
    
    func set(loadingFailed: Bool)
}
