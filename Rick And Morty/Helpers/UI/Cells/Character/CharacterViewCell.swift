//
//  CharacterViewCell.swift
//  Rick And Morty
//
//  Created by Anton Babich on 20.03.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import AlamofireImage
import UIKit

class CharacterViewCell: UITableViewCell {
    
    var character: Character! { // swiftlint:disable:this implicitly_unwrapped_optional
        didSet {
            if let url = URL(string: character.image) {
                characterImageView.af.setImage(withURL: url) { [weak self] response in
                    guard let `self` = self else {
                        return
                    }
                    
                    if let error = response.error, !error.isRequestCancelledError {
                        self.characterImageView.image = #imageLiteral(resourceName: "NotFound")
                    }
                    
                    self.characterImageView.isHidden = false
                    self.loadingActivityIndicator.stopAnimating()
                }
            }
            
            nameLabel.text = character.name
            speciesLabel.text = character.species
            
            characterImageView.layer.cornerRadius = characterImageView.bounds.midY
            characterImageView.clipsToBounds = true
            characterImageView.setNeedsDisplay()
            
            surfaceView.layer.cornerRadius = surfaceView.bounds.midY
            surfaceView.clipsToBounds = true
            surfaceView.setNeedsDisplay()
        }
    }

    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var surfaceView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        self.surfaceView.backgroundColor = UIColor(named: "color-surface")?.withAlphaComponent(highlighted ? 1 : 0.2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        self.loadingActivityIndicator.startAnimating()
        self.characterImageView.isHidden = true
        self.characterImageView.image = nil
    }
}
