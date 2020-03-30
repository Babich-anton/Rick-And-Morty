//
//  LocationCoordinator.swift
//  Rick And Morty
//
//  Created by Anton Babich on 19.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import Foundation
import UIKit

class LocationCoordinator: TabCoordinator {
    
    var rootController: UINavigationController
    var tabBarItem = UITabBarItem(.location, image: .location)
    var storyboard = UIStoryboard(.location)
    
    init() {
        let viewController: LocationViewController = storyboard.inflateVC()
        viewController.title = Tab.location.rawValue
        viewController.viewModel = LocationViewModel()
        
        rootController = UINavigationController(rootViewController: viewController)
        rootController.navigationBar.barStyle = .blackTranslucent
        tabBarItem.titlePositionAdjustment = tabTitlePosition
        rootController.tabBarItem = tabBarItem
    }
}
