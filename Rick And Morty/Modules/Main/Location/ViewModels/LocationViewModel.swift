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
    var nextPage: String? = nil
    
    override init() {
        super.init()
        
        self.loadNextPage(nil)
    }
    
    func loadNextPage(_ url: String?) {
        
        Locations.getLocations(from: url) { locations, error in
            self.nextPage = locations?.info.next
            
            if let locationsToAppend = locations?.results {
                var locations = self.locations.value
                
                for location in locationsToAppend {
                    if !locations.contains(where: { $0.id == location.id }) {
                        locations.append(location)
                    }
                }
                
                self.locations.accept(locations)
            } else if let error = error {
                showMessage(with: error.localizedDescription)
            }
        }
    }
    
    func search(_ query: String) {
        
        Locations.search(by: query) { locations, error in
            if let locations = locations {
                self.locations.accept(locations.results)
                self.nextPage = locations.info.next
            } else if let error = error {
                showMessage(with: error.localizedDescription)
            } else {
                self.locations.accept([])
            }
        }
    }
}
