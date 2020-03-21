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

class CharacterViewController: UITableViewController {

    var viewModel: CharacterViewModel!
    var selectedDetailsViewModel: CharacterDetailsViewModel?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        
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
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.characters.value.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowCharacterDetailsFromCharacters" {
            if let vc = segue.destination as? CharacterDetailsViewController {
                vc.characterViewModel = self.selectedDetailsViewModel!
            }
        }
    }
}
