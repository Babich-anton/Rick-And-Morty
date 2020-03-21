//
//  CharacterDetailsViewController.swift
//  Rick And Morty
//
//  Created by Anton Babich on 21.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import UIKit

class CharacterDetailsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var placeOfBirthLabel: UILabel!
    @IBOutlet weak var placeOfStayLabel: UILabel!
    
    var characterViewModel: CharacterDetailsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let character = characterViewModel.character.value
        
        if let url = URL(string: character.image) {
            imageView.load(url: url)
        }
        
        nameLabel.text         = character.name
        speciesLabel.text      = character.species
        statusLabel.text       = character.status
        genderLabel.text       = character.gender
        placeOfBirthLabel.text = character.origin.name
        placeOfStayLabel.text  = character.location.name
    }
}
