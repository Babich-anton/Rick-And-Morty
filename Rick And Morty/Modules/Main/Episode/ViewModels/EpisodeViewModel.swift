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
    var nextPage: String? = nil
    
    override init() {
        super.init()
        
        self.loadNextPage(nil)
    }
    
    func loadNextPage(_ url: String?) {
        
        Episodes.getEpisodes(from: url) { episodes, error in
            self.nextPage = episodes?.info.next
            
            if let episodesToAppend = episodes?.results {
                var episodes = self.episodes.value
                
                for episode in episodesToAppend {
                    if !episodes.contains(where: { $0.id == episode.id }) {
                        episodes.append(episode)
                    }
                }
                
                self.episodes.accept(episodes)
            } else if let error = error {
                showMessage(with: error.localizedDescription)
            }
        }
    }
    
    func search(_ query: String) {
        
        Episodes.search(by: query) { episodes, error in
            if let episodes = episodes {
                self.episodes.accept(episodes.results)
                self.nextPage = episodes.info.next
            } else if let error = error {
                showMessage(with: error.localizedDescription)
            } else {
                self.episodes.accept([])
            }
        }
    }
}
