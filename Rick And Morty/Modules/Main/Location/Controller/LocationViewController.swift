//
//  LocationViewController.swift
//  Rick And Morty
//
//  Created by Anton Babich on 19.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

fileprivate let CELL_IDENTIFIER = "location-cell"

class LocationViewController: UITableViewController {

    var viewModel: LocationViewModel!
    var selectedDetailsViewModel: LocationDetailsViewModel?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.definesPresentationContext = true
        
        let search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search"
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let cell = UINib(nibName: "LocationViewCell", bundle: nil)
        self.tableView.register(cell, forCellReuseIdentifier: CELL_IDENTIFIER)
        self.tableView.dataSource = nil
        self.tableView.delegate = self
        
        self.setupBinding()
    }

    private func setupBinding() {
        
        viewModel.locations.bind(to: self.tableView.rx.items(cellIdentifier: CELL_IDENTIFIER)) { row, model, cell in
            if let cell = cell as? LocationViewCell {
                cell.location = model
            }
        }.disposed(by: disposeBag)
        
        self.tableView.rx.modelSelected(Location.self)
            .map { $0 }
            .subscribe({ [unowned self] model in
                if let element = model.element {
                    self.selectedDetailsViewModel = LocationDetailsViewModel(location: element)
                    self.performSegue(withIdentifier: "ShowLocationDetailsFromCharacters", sender: nil)
                } else {
                    showMessage(with: "Could not found model. Please, try again!")
                }
            }).disposed(by: disposeBag)
        
        navigationItem.searchController?.searchBar.rx.text.orEmpty
            .subscribe(onNext: { query in
                self.viewModel.search(query)
            }).disposed(by: disposeBag)
        
        let isEmpty = tableView.rx.isEmpty(message: "No locations found")
        viewModel.locations.map({ $0.isEmpty }).distinctUntilChanged().bind(to: isEmpty).disposed(by: disposeBag)
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row + 1 >= self.viewModel.locations.value.count {
            if let nextPage = self.viewModel.nextPage, !nextPage.isEmpty {
                self.viewModel.loadNextPage(nextPage)
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.locations.value.count
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowLocationDetailsFromCharacters" {
            if let vc = segue.destination as? LocatioDetailsViewController {
                vc.locationViewModel = self.selectedDetailsViewModel!
            }
        }
    }
}
