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

class EpisodesViewController: UIViewController {

    var viewModel = EpisodeViewModel()
    var selectedDetailsViewModel: EpisodeDetailsViewModel?
    
    private let disposeBag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.definesPresentationContext = true
        
        let search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search"
        search.searchBar.tintColor = App.Color.onBackground
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
        
        self.setupBinding()
    }
    
    private func setupBinding() {
        viewModel.selectionDelegate = self
        viewModel.configure(tableView: self.tableView)
        
        navigationItem.searchController?.searchBar.rx.text.orEmpty
            .subscribe(onNext: { query in
                self.viewModel.search(query)
            }).disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEpisodeDetailsFromCharacters" {
            if let vc = segue.destination as? EpisodeDetailsViewController {
                vc.episodeDetailsViewModel = self.selectedDetailsViewModel
            }
        }
    }
}

extension EpisodesViewController: TableViewSelectionDelegate {
    
    func select(id: Int) {
        self.selectedDetailsViewModel = EpisodeDetailsViewModel(id: id)
        self.performSegue(withIdentifier: "ShowEpisodeDetailsFromCharacters", sender: nil)
    }
}
