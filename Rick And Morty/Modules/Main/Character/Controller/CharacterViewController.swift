//
//  CharacterViewController.swift
//  Rick And Morty
//
//  Created by Anton Babich on 19.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

fileprivate let CELL_IDENTIFIER = "character-cell"
fileprivate let SCOPE_BUTTON_TITLES = ["All", "Alive", "Dead", "Unknown"]

class CharacterViewController: UITableViewController {

    var viewModel: CharacterViewModel!
    var selectedDetailsViewModel: CharacterDetailsViewModel?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.definesPresentationContext = true
        
        let search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search"
        search.searchBar.scopeButtonTitles = SCOPE_BUTTON_TITLES
        search.searchBar.tintColor = UIColor(named: "color-on-background")
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let cell = UINib(nibName: "CharacterViewCell", bundle: nil)
        self.tableView.register(cell, forCellReuseIdentifier: CELL_IDENTIFIER)
        self.tableView.dataSource = nil
        self.tableView.delegate = self
        
        self.setupBinding()
    }
    
    private func setupBinding() {
        
        viewModel.characters.bind(to: self.tableView.rx.items(cellIdentifier: CELL_IDENTIFIER)) { row, model, cell in
            if let cell = cell as? CharacterViewCell {
                cell.character = model
            }
            
            cell.separatorInset = .zero
            cell.layoutMargins = .zero
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Character.self)
            .map { $0 }
            .subscribe({ [unowned self] model in
                if let element = model.element {
                    self.selectedDetailsViewModel = CharacterDetailsViewModel(character: element)
                    self.performSegue(withIdentifier: "ShowCharacterDetailsFromCharacters", sender: nil)
                } else {
                    showMessage(with: "Could not found model. Please, try again!")
                }
        }).disposed(by: disposeBag)
        
        navigationItem.searchController?.searchBar.rx.text.orEmpty
            .subscribe(onNext: { query in
                let status = SCOPE_BUTTON_TITLES[self.navigationItem.searchController?.searchBar.selectedScopeButtonIndex ?? 0]
                self.viewModel.search(query, status: status)
            }).disposed(by: disposeBag)
        
        navigationItem.searchController?.searchBar.rx.selectedScopeButtonIndex.subscribe(onNext: { [unowned self] index in
            let status = SCOPE_BUTTON_TITLES[index]
            self.viewModel.search(self.navigationItem.searchController?.searchBar.text ?? "", status: status)
        }).disposed(by: disposeBag)
        
        let isEmpty = tableView.rx.isEmpty(message: "No characters found")
        viewModel.characters.map({ $0.isEmpty }).distinctUntilChanged().bind(to: isEmpty).disposed(by: disposeBag)
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row + 1 >= self.viewModel.characters.value.count {
            if let nextPage = self.viewModel.nextPage, !nextPage.isEmpty {
                self.viewModel.loadNextPage(nextPage)
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.characters.value.count
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowCharacterDetailsFromCharacters" {
            if let vc = segue.destination as? CharacterDetailsViewController {
                vc.characterViewModel = self.selectedDetailsViewModel!
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
