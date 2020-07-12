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
    
    private var episodeDetailsViewModel: EpisodeDetailsViewModel! // swiftlint:disable:this implicitly_unwrapped_optional
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var episodeLabel: UILabel!
    @IBOutlet private weak var airDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        episodeDetailsViewModel.detailsDelegate = self
        episodeDetailsViewModel.setupBinding()
    }
    
    private func load(_ episode: Episode) {
        nameLabel.text = episode.name
        episodeLabel.text = episode.episode
        airDateLabel.text = episode.airDate
    }
    
    func set(_ viewModel: EpisodeDetailsViewModel) {
        self.episodeDetailsViewModel = viewModel
    }
    
    deinit {
        print("deinit EpisodeDetailsViewController")
    }
}

extension EpisodeDetailsViewController: EpisodeDetailsViewProtocol {
    
    func set(episode: Episode) {
        self.load(episode)
        
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
    
    func set(loadingFailed: Bool) {
        if loadingFailed {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// todo:: check deinit - fix problems with deinit
