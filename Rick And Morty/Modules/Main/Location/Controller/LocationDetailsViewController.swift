//
//  LocationDetailsViewController.swift
//  Rick And Morty
//
//  Created by Anton Babich on 21.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import UIKit

class LocatioDetailsViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dimensionLabel: UILabel!
    
    var locationViewModel: LocationDetailsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let location = locationViewModel.location.value
        
        self.nameLabel.text = location.name
        self.typeLabel.text = location.type
        self.dimensionLabel.text = location.dimension
        // TODO: - add table view with residents
    }
}
