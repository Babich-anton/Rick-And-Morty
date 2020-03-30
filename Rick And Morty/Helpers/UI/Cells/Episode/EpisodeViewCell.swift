//
//  EpisodeViewCell.swift
//  Rick And Morty
//
//  Created by Anton Babich on 21.03.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import UIKit

class EpisodeViewCell: UITableViewCell {
    
    @IBOutlet weak var airDateLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surfaceView: UIView!
    
    var episode: Episode! {
        didSet {
            airDateLabel.text = episode.airDate
            episodeLabel.text = episode.episode
            nameLabel.text = episode.name
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        self.surfaceView.backgroundColor = UIColor(named: "color-surface")?.withAlphaComponent(highlighted ? 1 : 0.2)
    }
}
