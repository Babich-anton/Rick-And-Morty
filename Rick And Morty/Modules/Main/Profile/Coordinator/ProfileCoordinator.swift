//
//  ProfileCoordinator.swift
//  Rick And Morty
//
//  Created by Anton Babich on 19.03.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import Foundation
import UIKit

class ProfileCoordinator: TabCoordinator {
    
    var rootController: UINavigationController
    var tabBarItem = UITabBarItem(.profile, image: .profile)
    var storyboard = UIStoryboard(.profile)
    
    init() {
        let viewController: ProfileViewController = storyboard.inflateVC()
        viewController.viewModel = ProfileViewModel()
        
        rootController = UINavigationController(rootViewController: viewController)
        rootController.navigationBar.barStyle = .blackTranslucent
        rootController.setNavigationBarHidden(true, animated: false)
        
        if UIDevice.current.orientation == .portrait {
            tabBarItem.titlePositionAdjustment = tabTitlePosition
        }
        
        rootController.tabBarItem = tabBarItem
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileCoordinator.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
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
