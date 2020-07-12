//
//  EpisodeViewModel.swift
//  Rick And Morty
//
//  Created by Anton Babich on 21.03.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class EpisodeViewModel: NSObject {
    
    private let disposeBag = DisposeBag()
    
    var episodes: BehaviorRelay<[Episode]> = BehaviorRelay<[Episode]>(value: [])
    var nextPage: String?
    
    weak var selectionDelegate: TableViewSelectionDelegate?
    
    override init() {
        super.init()
        self.loadNextPage(nil)
    }
    
    func loadNextPage(_ url: String?) {
        Episodes.getEpisodes(from: url, successHandler: { ep in
            var episodes = self.episodes.value
            self.nextPage = ep.info.next
            
            for episode in ep.results {
                if !episodes.contains(where: { $0.id == episode.id }) {
                    episodes.append(episode)
                }
            }
            
            self.episodes.accept(episodes)
        }, errorHandler: { error in
            showMessage(with: error.localizedDescription)
        })
    }
    
    func search(_ query: String) {
        Episodes.search(by: query, successHandler: { episodes in
            self.episodes.accept(episodes.results)
            self.nextPage = episodes.info.next
        }, errorHandler: { error in
            showMessage(with: error.localizedDescription)
        })
    }
}

extension EpisodeViewModel: TableViewProtocol {
    
    func configure(tableView: UITableView) {
        let cell = UINib(nibName: App.Tab.episodes.cellNib, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: App.Tab.episodes.cellIdentifier)
        tableView.dataSource = nil
        tableView.delegate = nil
        tableView.tableFooterView = UIView()
        
        self.bind(tableView)
        self.setupBinding(tableView)
    }
    
    private func setupBinding(_ tableView: UITableView) {
        let isEmpty = tableView.rx.isEmpty(message: "No episodes found")
        episodes.map({ $0.isEmpty }).distinctUntilChanged().bind(to: isEmpty).disposed(by: disposeBag)
        
        episodes.bind(to: tableView.rx.items(cellIdentifier: App.Tab.episodes.cellIdentifier)) { _, model, cell in
            if let cell = cell as? EpisodeViewCell {
                cell.episode = model
            }

            cell.separatorInset = separatorInsets
            cell.layoutMargins = .zero
        }.disposed(by: disposeBag)
    }
    
    private func bind(_ tableView: UITableView) {
        tableView.rx.modelSelected(Episode.self) // swiftlint:disable:this array_init
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
            
            if indexPath.row + 1 >= self.episodes.value.count {
                if let nextPage = self.nextPage, !nextPage.isEmpty {
                    self.loadNextPage(nextPage)
                }
            }
        }).disposed(by: disposeBag)
    }
}
