//
//  CharacterViewCell.swift
//  Rick And Morty
//
//  Created by Anton Babich on 20.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import AlamofireImage
import UIKit

class CharacterViewCell: UITableViewCell {

    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!

    var character: Character! {
        didSet {
            if let url = URL(string: character.image) {
                characterImageView.af.setImage(withURL: url) { response in
                    self.characterImageView.isHidden = false
                    self.loadingActivityIndicator.stopAnimating()
                }
            }
            
            nameLabel.text = character.name
            speciesLabel.text = character.species
            
            characterImageView.layer.cornerRadius = characterImageView.bounds.midY
            characterImageView.clipsToBounds = true
            characterImageView.setNeedsDisplay()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        self.loadingActivityIndicator.startAnimating()
        self.characterImageView.isHidden = true
        self.characterImageView.image = nil
    }
}
