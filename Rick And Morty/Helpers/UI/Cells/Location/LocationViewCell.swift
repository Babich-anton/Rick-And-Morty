//
//  LocationViewCell.swift
//  Rick And Morty
//
//  Created by Anton Babich on 21.03.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import UIKit

class LocationViewCell: UITableViewCell {
    
    var location: Location! { // swiftlint:disable:this implicitly_unwrapped_optional
        didSet {
            nameLabel.text = location.name
            typeLabel.text = location.type
        }
    }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var surfaceView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        self.surfaceView.backgroundColor = UIColor(named: "color-surface")?.withAlphaComponent(highlighted ? 1 : 0.2)
    }
}
