//
//  EpisodeDetailsViewController.swift
//  Rick And Morty
//
//  Created by Anton Babich on 21.03.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class EpisodeDetailsViewController: UIViewController {
    
    var episodeDetailsViewModel: EpisodeDetailsViewModel! // swiftlint:disable:this implicitly_unwrapped_optional
    
    private let disposeBag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var airDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBinding()
    }
    
    private func setupBinding() {
        episodeDetailsViewModel.episode.subscribe(onNext: { [weak self] location in
            guard let `self` = self else {
                return
            }
            
            if let location = location {
                self.load(location)
                
                self.mainView.alpha = 0
                self.mainView.isHidden = false
                
                UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseIn, animations: { [weak self] in
                    guard let `self` = self else {
                        return
                    }
                    
                    self.indicatorView.stopAnimating()
                    self.mainView.alpha = 1
                })
            }
        }).disposed(by: disposeBag)
        
        episodeDetailsViewModel.isFailedLoading.subscribe(onNext: { [weak self] value in
            if value {
                self?.navigationController?.popViewController(animated: true)
            }
        }).disposed(by: disposeBag)
    }
    
    private func load(_ episode: Episode) {
        nameLabel.text = episode.name
        episodeLabel.text = episode.episode
        airDateLabel.text = episode.airDate
    }
}