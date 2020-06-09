//
//  EpisodeDetailsViewModel.swift
//  Rick And Morty
//
//  Created by Anton Babich on 21.03.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import RxCocoa
import RxSwift

class EpisodeDetailsViewModel: NSObject {
    
    private let disposeBag = DisposeBag()
    
    var episode: BehaviorRelay<Episode?> = BehaviorRelay<Episode?>(value: nil)
    var isFailedLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    init(id: Int) {
        super.init()
        
        Episode.get(by: id, successHandler: { episode in
            self.episode.accept(episode)
        }, errorHandler: { error in
            showMessage(with: error.localizedDescription)
            self.isFailedLoading.accept(true)
        })
    }
}
