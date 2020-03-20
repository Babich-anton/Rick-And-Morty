//
//  ProfileCoordinator.swift
//  Rick And Morty
//
//  Created by Anton Babich on 19.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import Foundation
import UIKit

class ProfileCoordinator: TabCoordinator {
    
    var rootController: UINavigationController
    var tabBarItem = UITabBarItem(.profile, image: .profile)
    var storyboard = UIStoryboard(.profile)
    
    init() {
        let viewController: ProfileViewController = storyboard.inflateVC()
        
        rootController = UINavigationController(rootViewController: viewController)
        rootController.tabBarItem = tabBarItem
    }
}
