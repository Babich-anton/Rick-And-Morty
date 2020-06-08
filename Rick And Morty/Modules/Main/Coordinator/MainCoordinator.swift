//
//  MainCoordinator.swift
//  Rick And Morty
//
//  Created by Anton Babich on 18.03.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class MainCoordinator: CoordinatorProtocol {
    
    var tabs: [TabCoordinator]
    
    init() {
        self.tabs = [
            CharacterCoordinator(),
            LocationCoordinator(),
            EpisodesCoordinator(),
            ProfileCoordinator()
        ]
    }
    // TODO:: create color struct with single mode
    func start(from viewController: UIViewController) {
        let tabBarController = UITabBarController()
        
        tabBarController.viewControllers = tabs.map { $0.rootController }
        tabBarController.tabBar.barTintColor = UIColor(named: "color-surface")
        tabBarController.tabBar.tintColor = UIColor(named: "color-secondary")
        tabBarController.tabBar.unselectedItemTintColor = UIColor(named: "color-primary")
        tabBarController.modalPresentationStyle = .fullScreen
        
        UINavigationBar.appearance().barTintColor = UIColor(named: "color-surface")
        UINavigationBar.appearance().tintColor = UIColor(named: "color-on-background")
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "color-on-background") ?? .white]
        UINavigationBar.appearance().isTranslucent = false
        
        viewController.present(tabBarController, animated: true)
    }
    
    func coordinate(to coordinator: CoordinatorProtocol, from viewController: UIViewController) {
        coordinator.start(from: viewController)
    }
}

