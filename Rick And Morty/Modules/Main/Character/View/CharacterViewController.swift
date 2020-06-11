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
        
        let cell = UINib(nibName: App.Tab.character.cellNib, bundle: nil)
        self.tableView.register(cell, forCellReuseIdentifier: App.Tab.character.cellIdentifier)
        self.tableView.dataSource = nil
        self.tableView.delegate = nil
        self.tableView.tableFooterView = UIView()
        
        self.setupBinding()
    }
    
    private func setupBinding() {
        
        viewModel.characters.bind(to: self.tableView.rx.items(cellIdentifier: App.Tab.character.cellIdentifier)) { _, model, cell in
            if let cell = cell as? CharacterViewCell {
                cell.character = model
            }
            
            cell.separatorInset = .zero
            cell.layoutMargins = .zero
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Character.self)
            .map { $0 }
            .subscribe({ [weak self] model in
                guard let `self` = self else {
                    return
                }
                
                if let element = model.element {
                    self.selectedDetailsViewModel = CharacterDetailsViewModel(id: element.id)
                    self.performSegue(withIdentifier: "ShowCharacterDetailsFromCharacters", sender: nil)
                } else {
                    showMessage(with: "Could not found model. Please, try again!")
                }
        }).disposed(by: disposeBag)
            
        self.tableView.rx.willDisplayCell.subscribe(onNext: { _, indexPath in
            if indexPath.row + 1 >= self.viewModel.characters.value.count {
                if let nextPage = self.viewModel.nextPage, !nextPage.isEmpty {
                    self.viewModel.loadNextPage(nextPage)
                }
            }
        }).disposed(by: disposeBag)
        
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
        
        let isEmpty = tableView.rx.isEmpty(message: "No characters found")
        viewModel.characters.map({ $0.isEmpty }).distinctUntilChanged().bind(to: isEmpty).disposed(by: disposeBag)
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

// MARK: - Table view delegate

extension CharacterViewController: UITableViewDelegate { }
