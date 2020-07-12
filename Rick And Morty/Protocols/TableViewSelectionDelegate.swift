//
//  TableViewSelectionDelegate.swift
//  Rick And Morty
//
//  Created by Anton Babich on 12.07.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import RxSwift

protocol TableViewSelectionDelegate: class {
    
    func select(id: Int)
}
