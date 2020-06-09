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
        viewController.title = App.Tab.episodes.rawValue
        viewController.viewModel = EpisodeViewModel()
        
        rootController = UINavigationController(rootViewController: viewController)
        rootController.navigationBar.barStyle = .blackTranslucent
            
        if UIDevice.current.orientation == .portrait {
            tabBarItem.titlePositionAdjustment = tabTitlePosition
        }
        
        rootController.tabBarItem = tabBarItem
        
        NotificationCenter.default.addObserver(self, selector: #selector(EpisodesCoordinator.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func rotated() {
        if UIDevice.current.orientation.isLandscape {
            tabBarItem.titlePositionAdjustment = UITabBarItem().titlePositionAdjustment
        } else {
            tabBarItem.titlePositionAdjustment = tabTitlePosition
        }
        
        rootController.tabBarItem = tabBarItem
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
}
