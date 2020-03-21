//
//  MainCoordinator.swift
//  Rick And Morty
//
//  Created by Anton Babich on 18.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class MainCoordinator: CoordinatorProtocol {
    
    var tabBarController: UITabBarController?
    var tabs: [TabCoordinator]
    
    init() {
        self.tabs = [
            CharacterCoordinator(),
            LocationCoordinator(),
            EpisodesCoordinator(),
            ProfileCoordinator()
        ]
    }
    
    func start(from viewController: UIViewController) {
        self.tabBarController = UITabBarController()
        self.tabBarController?.viewControllers = tabs.map { $0.rootController }
        self.tabBarController?.tabBar.tintColor = UIColor(named: "color-active")
        self.tabBarController?.tabBar.barTintColor = UIColor(named: "color-dark")
        self.tabBarController?.tabBar.unselectedItemTintColor = UIColor(named: "color-light")
        
        viewController.present(self.tabBarController!, animated: true)
    }
    
    func coordinate(to coordinator: CoordinatorProtocol, from viewController: UIViewController) {
        coordinator.start(from: viewController)
    }
}

protocol TabCoordinator {
    
    var rootController: UINavigationController { get }
    var tabBarItem: UITabBarItem { get }
    var storyboard: UIStoryboard { get }
}

enum Tab: String {
    
    case character = "Character"
    case location  = "Location"
    case episodes  = "Episodes"
    case profile   = "Profile"
}