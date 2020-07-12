//
//  CharacterViewModel.swift
//  Rick And Morty
//
//  Created by Anton Babich on 20.03.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import RxSwift
import RxCocoa

class CharacterViewModel: NSObject, ViewModel {
    
    private var characters: BehaviorRelay<[Character]> = BehaviorRelay<[Character]>(value: [])
    private var nextPage: String?
    
    private let disposeBag = DisposeBag()
    
    weak var selectionDelegate: TableViewSelectionDelegate?
    
    override init() {
        super.init()
        self.loadNextPage(nil)
    }
    
    func getDisposeBag() -> DisposeBag {
        return disposeBag
    }
}

extension CharacterViewModel: CharacterViewModelProtocol {
    
    func loadNextPage(_ url: String?) {
        Characters.getCharacters(from: url, successHandler: { ch in
            self.nextPage = ch.info.next
            var characters = self.characters.value
            
            for character in ch.results {
                if !characters.contains(where: { $0.id == character.id }) {
                    characters.append(character)
                }
            }
            
            self.characters.accept(characters)
        }, errorHandler: { error in
            showMessage(with: error.localizedDescription)
        })
    }
    
    func search(_ query: String, status: String) {
        Characters.search(by: query, status: status, successHandler: { characters in
            self.characters.accept(characters.results)
            self.nextPage = characters.info.next
        }, errorHandler: { error in
            showMessage(with: error.localizedDescription)
        })
    }
}

extension CharacterViewModel: TableViewProtocol {
    
    func configure(tableView: UITableView) {
        let cell = UINib(nibName: App.Tab.character.cellNib, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: App.Tab.character.cellIdentifier)
        tableView.dataSource = nil
        tableView.delegate = nil
        tableView.tableFooterView = UIView()
        
        self.bind(tableView)
        self.setupBinding(tableView)
    }
    
    private func setupBinding(_ tableView: UITableView) {
        let isEmpty = tableView.rx.isEmpty(message: "No characters found")
        characters.map({ $0.isEmpty }).distinctUntilChanged().bind(to: isEmpty).disposed(by: disposeBag)
        
        characters.bind(to: tableView.rx.items(cellIdentifier: App.Tab.character.cellIdentifier)) { _, model, cell in
            if let cell = cell as? CharacterViewCell {
                cell.character = model
            }
            
            cell.separatorInset = .zero
            cell.layoutMargins = .zero
        }.disposed(by: disposeBag)
    }
    
    private func bind(_ tableView: UITableView) {
        tableView.rx.modelSelected(Character.self) // swiftlint:disable:this array_init
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
            
            if indexPath.row + 1 >= self.characters.value.count {
                if let nextPage = self.nextPage, !nextPage.isEmpty {
                    self.loadNextPage(nextPage)
                }
            }
        }).disposed(by: disposeBag)
    }
}
