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
    
    var location: BehaviorRelay<Location>!
    
    init(location: Location) {
        super.init()
        
        self.location = BehaviorRelay<Location>(value: location)
    }
}
