//
//  LocationViewModel.swift
//  Rick And Morty
//
//  Created by Anton Babich on 21.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import RxCocoa
import RxSwift

class LocationViewModel: NSObject {
    
    private var disposeBag = DisposeBag()
    
    var locations: BehaviorRelay<[Location]> = BehaviorRelay<[Location]>(value: [])
    var nextPage: String? = nil
    
    override init() {
        super.init()
        
        self.loadNextPage(nil)
    }
    
    func loadNextPage(_ url: String?) {
        
        Locations.getLocations(from: url) { locations, error in
            if let locations = locations {
                self.locations.accept(locations.results)
                self.nextPage = locations.info.next
            } else if let error = error {
                showMessage(with: error.localizedDescription)
            }
        }
    }
}
