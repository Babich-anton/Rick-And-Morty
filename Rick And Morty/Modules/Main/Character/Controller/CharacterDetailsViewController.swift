//
//  CharacterDetailsViewController.swift
//  Rick And Morty
//
//  Created by Anton Babich on 21.03.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class CharacterDetailsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detailsStackView: UIStackView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var placeOfBirthLabel: UILabel!
    @IBOutlet weak var placeOfStayLabel: UILabel!
    
    var characterViewModel: CharacterDetailsViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        characterViewModel.character.subscribe(onNext: { [unowned self] character in
            if let character = character {
                self.load(character)
                
                self.imageView.alpha = 0
                self.imageView.isHidden = false
                self.detailsStackView.alpha = 0
                self.detailsStackView.isHidden = false
                
                UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseIn, animations: { [unowned self] in
                    self.indicatorView.stopAnimating()
                    self.imageView.alpha = 1
                    self.detailsStackView.alpha = 1
                })
            }
        }).disposed(by: disposeBag)
        
        characterViewModel.isFailedLoading.subscribe(onNext: { [unowned self] value in
            if value {
                self.navigationController?.popViewController(animated: true)
            }
        }).disposed(by: disposeBag)
        
        imageView.layer.cornerRadius = imageView.bounds.midY
        imageView.clipsToBounds = true
        imageView.setNeedsDisplay()
    }
    
    private func load(_ character: Character) {
        
        if let url = URL(string: character.image) {
            imageView.af.setImage(withURL: url)
        }
        
        nameLabel.text         = character.name
        speciesLabel.text      = character.species
        statusLabel.text       = character.status
        genderLabel.text       = character.gender
        placeOfBirthLabel.text = character.origin.name
        placeOfStayLabel.text  = character.location.name
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
