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
    
    var locationViewModel: LocationDetailsViewModel!
    
    private let disposeBag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dimensionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationViewModel.location.subscribe(onNext: { [weak self] location in
            if let location = location {
                guard let `self` = self else {
                    return
                }
                
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
        }).disposed(by: disposeBag)
        
        locationViewModel.isFailedLoading.subscribe(onNext: { [weak self] value in
            if value {
                guard let `self` = self else {
                    return
                }
                
                self.navigationController?.popViewController(animated: true)
            }
        }).disposed(by: disposeBag)
    }
    
    private func load(_ location: Location) {
        self.nameLabel.text = location.name
        self.typeLabel.text = location.type
        self.dimensionLabel.text = location.dimension
    }
}
