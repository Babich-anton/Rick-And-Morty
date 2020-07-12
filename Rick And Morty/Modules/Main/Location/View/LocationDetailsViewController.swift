//
//  LocationDetailsViewController.swift
//  Rick And Morty
//
//  Created by Anton Babich on 21.03.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class LocationDetailsViewController: UIViewController {
    
    private var locationViewModel: LocationDetailsViewModel! // swiftlint:disable:this implicitly_unwrapped_optional
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var dimensionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationViewModel.detailsDelegate = self
        locationViewModel.setupBinding()
    }
    
    private func load(_ location: Location) {
        self.nameLabel.text = location.name
        self.typeLabel.text = location.type
        self.dimensionLabel.text = location.dimension
    }
    
    func set(_ viewModel: LocationDetailsViewModel) {
        self.locationViewModel = viewModel
    }
    
    deinit {
        print("deinit LocationDetailsViewController")
    }
}

extension LocationDetailsViewController: LocationDetailsViewProtocol {
    
    func set(location: Location) {
        self.load(location)
        
        self.mainView.alpha = 0
        self.mainView.isHidden = false
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseIn, animations: { [weak self] in
            guard let `self` = self else {
                return
            }
            
            self.indicatorView.stopAnimating()
            self.mainView.alpha = 1
        })
    }
    
    func set(loadingFailed: Bool) {
        if loadingFailed {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
