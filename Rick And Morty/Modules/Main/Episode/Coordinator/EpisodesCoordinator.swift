//
//  EpisodesCoordinator.swift
//  Rick And Morty
//
//  Created by Anton Babich on 19.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import Foundation
import UIKit

class EpisodesCoordinator: TabCoordinator {
    
    var rootController: UINavigationController
    var tabBarItem = UITabBarItem(.episodes, image: .episodes)
    var storyboard = UIStoryboard(.episodes)
    
    init() {
        let viewController: EpisodesViewController = storyboard.inflateVC()
        viewController.title = Tab.episodes.rawValue
        viewController.viewModel = EpisodeViewModel()
        
        rootController = UINavigationController(rootViewController: viewController)
        tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: -4)
        rootController.tabBarItem = tabBarItem
    }
}

