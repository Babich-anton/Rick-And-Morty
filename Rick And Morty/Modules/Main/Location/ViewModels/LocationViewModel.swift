//
//  LocationViewModel.swift
//  Rick And Morty
//
//  Created by Anton Babich on 21.03.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import RxCocoa
import RxSwift

class LocationViewModel: NSObject {
    
    private var disposeBag = DisposeBag()
    
    var locations: BehaviorRelay<[Location]> = BehaviorRelay<[Location]>(value: [])
    var nextPage: String?
    
    override init() {
        super.init()
        
        self.loadNextPage(nil)
    }
    
    func loadNextPage(_ url: String?) {
        Locations.getLocations(from: url, successHandler: { loc in
            self.nextPage = loc.info.next
            var locations = self.locations.value
            
            for location in loc.results {
                if !locations.contains(where: { $0.id == location.id }) {
                    locations.append(location)
                }
            }
            
            self.locations.accept(locations)
        }, errorHandler: { error in
            showMessage(with: error.localizedDescription)
        })
    }
    
    func search(_ query: String) {
        Locations.search(by: query, successHandler: { locations in
            self.locations.accept(locations.results)
            self.nextPage = locations.info.next
        }, errorHandler: { error in
            showMessage(with: error.localizedDescription)
        })
    }
}
