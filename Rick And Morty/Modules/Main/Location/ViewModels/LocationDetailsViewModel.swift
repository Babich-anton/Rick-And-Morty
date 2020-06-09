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
    
    private let disposeBag = DisposeBag()
    
    var location: BehaviorRelay<Location?> = BehaviorRelay<Location?>(value: nil)
    var isFailedLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    init(id: Int) {
        super.init()
        
        Location.get(by: id, successHandler: { location in
            self.location.accept(location)
        }, errorHandler: { error in
            showMessage(with: error.localizedDescription)
            self.isFailedLoading.accept(true)
        })
    }
}
