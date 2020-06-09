//
//  EpisodeViewModel.swift
//  Rick And Morty
//
//  Created by Anton Babich on 21.03.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import RxCocoa
import RxSwift

class EpisodeViewModel: NSObject {
    
    private let disposeBag = DisposeBag()
    
    var episodes: BehaviorRelay<[Episode]> = BehaviorRelay<[Episode]>(value: [])
    var nextPage: String?
    
    override init() {
        super.init()
        
        self.loadNextPage(nil)
    }
    
    func loadNextPage(_ url: String?) {
        Episodes.getEpisodes(from: url, successHandler: { ep in
            var episodes = self.episodes.value
            self.nextPage = ep.info.next
            
            for episode in ep.results {
                if !episodes.contains(where: { $0.id == episode.id }) {
                    episodes.append(episode)
                }
            }
            
            self.episodes.accept(episodes)
        }, errorHandler: { error in
            showMessage(with: error.localizedDescription)
        })
    }
    
    func search(_ query: String) {
        Episodes.search(by: query, successHandler: { episodes in
            self.episodes.accept(episodes.results)
            self.nextPage = episodes.info.next
        }, errorHandler: { error in
            showMessage(with: error.localizedDescription)
        })
    }
}
