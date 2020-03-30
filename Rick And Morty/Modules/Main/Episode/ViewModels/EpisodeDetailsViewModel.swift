//
//  EpisodeDetailsViewModel.swift
//  Rick And Morty
//
//  Created by Anton Babich on 21.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import RxCocoa
import RxSwift

class EpisodeDetailsViewModel: NSObject {
    
    private let disposeBag = DisposeBag()
    
    var episode: BehaviorRelay<Episode?> = BehaviorRelay<Episode?>(value: nil)
    var isFailedLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    init(id: Int) {
        super.init()
        
        Episode.get(by: id) { episode, error in
            if let error = error {
                showMessage(with: error.localizedDescription)
                self.isFailedLoading.accept(true)
            } else if let episode = episode {
                self.episode.accept(episode)
            }
        }
    }
}
