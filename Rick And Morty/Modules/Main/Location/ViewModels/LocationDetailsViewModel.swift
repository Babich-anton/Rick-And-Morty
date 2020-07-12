//
//  LocationDetailsViewModel.swift
//  Rick And Morty
//
//  Created by Anton Babich on 21.03.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import RxCocoa
import RxSwift

class LocationDetailsViewModel: NSObject {
    
    private var location: BehaviorRelay<Location?> = BehaviorRelay<Location?>(value: nil)
    private var isFailedLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    private let disposeBag = DisposeBag()
    
    weak var detailsDelegate: LocationDetailsViewProtocol?
    
    init(id: Int) {
        super.init()
        
        Location.get(by: id, successHandler: { location in
            self.location.accept(location)
            self.isFailedLoading.accept(false)
        }, errorHandler: { error in
            showMessage(with: error.localizedDescription)
            self.isFailedLoading.accept(true)
        })
    }
    
    func setupBinding() {
        location.subscribe(onNext: { [weak self] location in
            if let location = location {
                self?.detailsDelegate?.set(location: location)
            }
        }).disposed(by: disposeBag)
        
        isFailedLoading.subscribe(onNext: { [weak self] value in
            self?.detailsDelegate?.set(loadingFailed: value)
        }).disposed(by: disposeBag)
    }
}
