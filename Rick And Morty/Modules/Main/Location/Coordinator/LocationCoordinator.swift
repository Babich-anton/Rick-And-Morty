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
        
        rootController = UINavigationController(rootViewController: viewController)
        rootController.tabBarItem = tabBarItem
    }
}