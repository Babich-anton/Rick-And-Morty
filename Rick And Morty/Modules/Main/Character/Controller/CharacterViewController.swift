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
        
//        tableView.rx.modelSelected(Place.self)
//            .map{ URL(string: $0.url) }
//            .subscribe(onNext: { [weak self] url in
//                guard let url = url else {
//                    return
//                }
//                self?.present(SFSafariViewController(url: url), animated: true)
//        }).disposed(by: disposeBag)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.characters.value.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
