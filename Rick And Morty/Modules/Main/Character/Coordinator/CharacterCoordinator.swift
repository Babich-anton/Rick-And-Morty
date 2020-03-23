//
//  CharacterCoordinator.swift
//  Rick And Morty
//
//  Created by Anton Babich on 19.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import UIKit

class CharacterCoordinator: TabCoordinator {
    
    var rootController: UINavigationController
    var tabBarItem = UITabBarItem(.character, image: .character)
    var storyboard = UIStoryboard(.character)
    
    init() {
        let selectViewController: CharacterViewController = storyboard.inflateVC()
        selectViewController.title = Tab.character.rawValue
        selectViewController.viewModel = CharacterViewModel()
        
        rootController = UINavigationController(rootViewController: selectViewController)
        tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: -4)
        rootController.tabBarItem = tabBarItem
    }
}
