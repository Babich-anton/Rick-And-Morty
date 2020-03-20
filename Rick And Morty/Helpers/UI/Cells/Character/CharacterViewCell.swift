//
//  CharacterViewCell.swift
//  Rick And Morty
//
//  Created by Anton Babich on 20.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import UIKit

class CharacterViewCell: UITableViewCell {

    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!

    var character: Character! {
        didSet {
            // TODO: add cache for images
            if let url = URL(string: character.image) {
                characterImageView.load(url: url)
            }
            
            nameLabel.text = character.name
            speciesLabel.text = character.species
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
