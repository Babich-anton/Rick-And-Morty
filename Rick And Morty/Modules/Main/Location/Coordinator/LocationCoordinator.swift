//
//  LocationCoordinator.swift
//  Rick And Morty
//
//  Created by Anton Babich on 19.03.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import Foundation
import UIKit

class LocationCoordinator: TabCoordinator {
    
    var rootController: UINavigationController
    var tabBarItem = UITabBarItem(.location, image: .location)
    var storyboard = UIStoryboard(.location)
    
    init() {
        let viewController: LocationViewController = storyboard.inflateVC()
        viewController.title = App.Tab.location.rawValue
        
        rootController = UINavigationController(rootViewController: viewController)
        rootController.navigationBar.barStyle = .blackTranslucent
        
        if UIDevice.current.orientation == .portrait {
            tabBarItem.titlePositionAdjustment = tabTitlePosition
        }
         
        rootController.tabBarItem = tabBarItem
        
        NotificationCenter.default.addObserver(self, selector: #selector(LocationCoordinator.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
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
