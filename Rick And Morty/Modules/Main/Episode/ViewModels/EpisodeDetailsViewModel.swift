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
    
    var episode: BehaviorRelay<Episode>!
    
    init(episode: Episode) {
        super.init()
        
        self.episode = BehaviorRelay<Episode>(value: episode)
    }
}
