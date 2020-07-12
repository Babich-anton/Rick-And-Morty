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
    
    private var characterViewModel: CharacterDetailsViewModel! // swiftlint:disable:this implicitly_unwrapped_optional
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var detailsStackView: UIStackView!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var speciesLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var genderLabel: UILabel!
    @IBOutlet private weak var placeOfBirthLabel: UILabel!
    @IBOutlet private weak var placeOfStayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        characterViewModel.detailsDelegate = self
        characterViewModel.setupBinding()
        
        imageView.layer.cornerRadius = imageView.bounds.midY
        imageView.clipsToBounds = true
        imageView.setNeedsDisplay()
    }
    
    private func load(_ character: Character) {
        if let url = URL(string: character.image) {
            imageView.af.setImage(withURL: url)
        }
        
        nameLabel.text = character.name
        speciesLabel.text = character.species
        statusLabel.text = character.status
        genderLabel.text = character.gender
        placeOfBirthLabel.text = character.origin.name
        placeOfStayLabel.text = character.location.name
    }
    
    func set(_ viewModel: CharacterDetailsViewModel) {
        self.characterViewModel = viewModel
    }
    
    deinit {
        print("deinit CharacterDetailsViewController")
    }
}

extension CharacterDetailsViewController: CharacterDetailsViewProtocol {
    
    func set(character: Character) {
        self.load(character)
        
        self.imageView.alpha = 0
        self.imageView.isHidden = false
        self.detailsStackView.alpha = 0
        self.detailsStackView.isHidden = false
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseIn, animations: { [weak self] in
            guard let `self` = self else {
                return
            }
            
            self.indicatorView.stopAnimating()
            self.imageView.alpha = 1
            self.detailsStackView.alpha = 1
        })
    }
    
    func set(loadingFailed: Bool) {
        if loadingFailed {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
