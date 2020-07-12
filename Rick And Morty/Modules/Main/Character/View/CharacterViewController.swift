//
//  CharacterViewController.swift
//  Rick And Morty
//
//  Created by Anton Babich on 19.03.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class CharacterViewController: UIViewController {

    var viewModel = CharacterViewModel()
    var selectedDetailsViewModel: CharacterDetailsViewModel?
    
    private let disposeBag = DisposeBag()
    private var avaliableSearchButtons: [CharacterStatus] = [.all, .alive, .dead, .unknown]
    
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
        search.searchBar.scopeButtonTitles = avaliableSearchButtons.getTitles()
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
                if let index = self.navigationItem.searchController?.searchBar.selectedScopeButtonIndex {
                    let status = self.avaliableSearchButtons[index].rawValue
                    self.viewModel.search(query, status: status)
                }
            }).disposed(by: disposeBag)
        
        navigationItem.searchController?.searchBar.rx.selectedScopeButtonIndex.subscribe(onNext: { [weak self] index in
            guard let `self` = self else {
                return
            }
            
            let status = self.avaliableSearchButtons[index].rawValue
            self.viewModel.search(self.navigationItem.searchController?.searchBar.text ?? "", status: status)
        }).disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCharacterDetailsFromCharacters" {
            if let vc = segue.destination as? CharacterDetailsViewController {
                if let viewModel = self.selectedDetailsViewModel {
                    vc.characterViewModel = viewModel
                }
            }
        }
    }
}

extension CharacterViewController: TableViewSelectionDelegate {
    
    func select(id: Int) {
        self.selectedDetailsViewModel = CharacterDetailsViewModel(id: id)
        self.performSegue(withIdentifier: "ShowCharacterDetailsFromCharacters", sender: nil)
    }
}
