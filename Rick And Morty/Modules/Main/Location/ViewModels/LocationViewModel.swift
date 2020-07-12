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
    
    weak var selectionDelegate: TableViewSelectionDelegate?
    
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

extension LocationViewModel: TableViewProtocol {
    
    func configure(tableView: UITableView) {
        let cell = UINib(nibName: App.Tab.location.cellNib, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: App.Tab.location.cellIdentifier)
        tableView.dataSource = nil
        tableView.delegate = nil
        tableView.separatorInset = .zero
        tableView.tableFooterView = UIView()
        
        self.bind(tableView)
        self.setupBinding(tableView)
    }
    
    private func setupBinding(_ tableView: UITableView) {
        let isEmpty = tableView.rx.isEmpty(message: "No locations found")
        locations.map({ $0.isEmpty }).distinctUntilChanged().bind(to: isEmpty).disposed(by: disposeBag)
        
        locations.bind(to: tableView.rx.items(cellIdentifier: App.Tab.location.cellIdentifier)) { _, model, cell in
            if let cell = cell as? LocationViewCell {
                cell.location = model
            }

            cell.separatorInset = separatorInsets
            cell.layoutMargins = .zero
        }.disposed(by: disposeBag)
    }
    
    private func bind(_ tableView: UITableView) {
        tableView.rx.modelSelected(Location.self) // swiftlint:disable:this array_init
            .map { $0 }
            .subscribe({ [weak self] model in
                if let element = model.element {
                    self?.selectionDelegate?.select(id: element.id)
                } else {
                    showMessage(with: "Could not found model. Please, try again!")
                }
            }).disposed(by: disposeBag)
            
        tableView.rx.willDisplayCell.subscribe(onNext: { [weak self] _, indexPath in
            guard let `self` = self else {
                return
            }
            
            if indexPath.row + 1 >= self.locations.value.count {
                if let nextPage = self.nextPage, !nextPage.isEmpty {
                    self.loadNextPage(nextPage)
                }
            }
        }).disposed(by: disposeBag)
    }
}
