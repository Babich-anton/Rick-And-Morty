//
//  EpisodesCoordinator.swift
//  Rick And Morty
//
//  Created by Anton Babich on 19.03.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
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
        rootController.navigationBar.barStyle = .blackTranslucent
        tabBarItem.titlePositionAdjustment = tabTitlePosition
        rootController.tabBarItem = tabBarItem
    }
}

