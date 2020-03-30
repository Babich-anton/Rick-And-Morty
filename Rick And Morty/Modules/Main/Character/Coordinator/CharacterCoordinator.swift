//
//  CharacterCoordinator.swift
//  Rick And Morty
//
//  Created by Anton Babich on 19.03.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
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
        rootController.navigationBar.barStyle = .blackTranslucent
        tabBarItem.titlePositionAdjustment = tabTitlePosition
        rootController.tabBarItem = tabBarItem
    }
}
