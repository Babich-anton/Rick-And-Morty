//
//  EpisodesViewController.swift
//  Rick And Morty
//
//  Created by Anton Babich on 19.03.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

private let CELL_IDENTIFIER = "episode-cell"

class EpisodesViewController: UITableViewController {

    var viewModel: EpisodeViewModel!
    var selectedDetailsViewModel: EpisodeDetailsViewModel?
    
    private let disposeBag = DisposeBag()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.definesPresentationContext = true
        
        let search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search"
        search.searchBar.tintColor = UIColor(named: "color-on-background")
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let cell = UINib(nibName: "EpisodeViewCell", bundle: nil)
        self.tableView.register(cell, forCellReuseIdentifier: CELL_IDENTIFIER)
        self.tableView.dataSource = nil
        self.tableView.delegate = self
        self.tableView.separatorInset = .zero
        self.tableView.separatorColor = .clear
        self.tableView.tableFooterView = UIView()
        
        self.setupBinding()
    }
    
    // MARK: - Table view data source
    // todo:: data sources to view model

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.episodes.value.count
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEpisodeDetailsFromCharacters" {
            if let vc = segue.destination as? EpisodeDetailsViewController {
                vc.episodeViewModel = self.selectedDetailsViewModel
            }
        }
    }
    
    private func setupBinding() {
        viewModel.episodes.bind(to: self.tableView.rx.items(cellIdentifier: CELL_IDENTIFIER)) { _, model, cell in
            if let cell = cell as? EpisodeViewCell {
                cell.episode = model
            }

            cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            cell.layoutMargins = .zero
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Episode.self)
            .map { $0 }
            .subscribe({ [weak self] model in
                guard let `self` = self else {
                    return
                }
                
                if let element = model.element {
                    self.selectedDetailsViewModel = EpisodeDetailsViewModel(id: element.id)
                    self.performSegue(withIdentifier: "ShowEpisodeDetailsFromCharacters", sender: nil)
                } else {
                    showMessage(with: "Could not found model. Please, try again!")
                }
            }).disposed(by: disposeBag)
        
        self.tableView.rx.willDisplayCell.subscribe(onNext: { _, indexPath in
            if indexPath.row + 1 >= self.viewModel.episodes.value.count {
                if let nextPage = self.viewModel.nextPage, !nextPage.isEmpty {
                    self.viewModel.loadNextPage(nextPage)
                }
            }
        }).disposed(by: disposeBag)
            
        navigationItem.searchController?.searchBar.rx.text.orEmpty
            .subscribe(onNext: { query in
                self.viewModel.search(query)
            }).disposed(by: disposeBag)
            
        let isEmpty = tableView.rx.isEmpty(message: "No episodes found")
        viewModel.episodes.map({ $0.isEmpty }).distinctUntilChanged().bind(to: isEmpty).disposed(by: disposeBag)
    }
}
