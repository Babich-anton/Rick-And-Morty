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
    
    private var episode: BehaviorRelay<Episode?> = BehaviorRelay<Episode?>(value: nil)
    private var isFailedLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    private let disposeBag = DisposeBag()
    
    weak var detailsDelegate: EpisodeDetailsViewProtocol?
    
    init(id: Int) {
        super.init()
        
        Episode.get(by: id, successHandler: { episode in
            self.episode.accept(episode)
        }, errorHandler: { error in
            showMessage(with: error.localizedDescription)
            self.isFailedLoading.accept(true)
        })
    }
    
    func setupBinding() {
        episode.subscribe(onNext: { [weak self] episode in
            if let episode = episode {
                self?.detailsDelegate?.set(episode: episode)
            }
        }).disposed(by: disposeBag)
        
        isFailedLoading.subscribe(onNext: { [weak self] value in
            self?.detailsDelegate?.set(loadingFailed: value)
        }).disposed(by: disposeBag)
    }
}
