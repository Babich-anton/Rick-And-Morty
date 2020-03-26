//
//  EpisodeDetailsViewController.swift
//  Rick And Morty
//
//  Created by Anton Babich on 21.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import UIKit

class EpisodeDetailsViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var airDateLabel: UILabel!
    
    var episodeViewModel: EpisodeDetailsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let episode = episodeViewModel.episode.value
        
        nameLabel.text = episode.name
        episodeLabel.text = episode.episode
        airDateLabel.text = episode.airDate
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
