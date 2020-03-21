//
//  EpisodeViewModel.swift
//  Rick And Morty
//
//  Created by Anton Babich on 21.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import RxCocoa
import RxSwift

class EpisodeViewModel: NSObject {
    
    private let disposeBag = DisposeBag()
    
    var episodes: BehaviorRelay<[Episode]> = BehaviorRelay<[Episode]>(value: [])
    var nextPage: String? = nil
    
    override init() {
        super.init()
        
        self.loadNextPage(nil)
    }
    
    func loadNextPage(_ url: String?) {
        
        Episodes.getEpisodes(from: url) { episodes, error in
            if let episodes = episodes {
                self.episodes.accept(episodes.results)
                self.nextPage = episodes.info.next
            } else if let error = error {
                showMessage(with: error.localizedDescription)
            }
        }
    }
}
