//
//  LocationDetailsViewModel.swift
//  Rick And Morty
//
//  Created by Anton Babich on 21.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import RxCocoa
import RxSwift

class LocationDetailsViewModel: NSObject {
    
    private let disposeBag = DisposeBag()
    
    var location: BehaviorRelay<Location?> = BehaviorRelay<Location?>(value: nil)
    var isFailedLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    init(id: Int) {
        super.init()
        
        Location.get(by: id) { location, error in
            if let error = error {
                showMessage(with: error.localizedDescription)
                self.isFailedLoading.accept(true)
            } else if let location = location {
                self.location.accept(location)
            }
        }
    }
}
