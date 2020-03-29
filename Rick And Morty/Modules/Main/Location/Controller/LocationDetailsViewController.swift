//
//  LocationDetailsViewController.swift
//  Rick And Morty
//
//  Created by Anton Babich on 21.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class LocatioDetailsViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dimensionLabel: UILabel!
    
    var locationViewModel: LocationDetailsViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationViewModel.location.subscribe(onNext: { [unowned self] location in
            if let location = location {
                self.load(location)
                
                self.mainView.alpha = 0
                self.mainView.isHidden = false
                
                UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseIn, animations: { [unowned self] in
                    self.indicatorView.stopAnimating()
                    self.mainView.alpha = 1
                })
            }
        }).disposed(by: disposeBag)
        
        locationViewModel.isFailedLoading.subscribe(onNext: { [unowned self] value in
            if value {
                self.navigationController?.popViewController(animated: true)
            }
        }).disposed(by: disposeBag)
    }
    
    private func load(_ location: Location) {
        
        self.nameLabel.text = location.name
        self.typeLabel.text = location.type
        self.dimensionLabel.text = location.dimension
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
