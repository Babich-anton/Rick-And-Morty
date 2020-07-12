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
    
    let tabBarController = UITabBarController()
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
        tabBarController.viewControllers = tabs.map { $0.rootController }
        tabBarController.tabBar.barTintColor = App.Color.surface
        tabBarController.tabBar.tintColor = App.Color.secondary
        tabBarController.tabBar.unselectedItemTintColor = App.Color.primary
        tabBarController.modalPresentationStyle = .fullScreen
        
        UINavigationBar.appearance().barTintColor = App.Color.surface
        UINavigationBar.appearance().tintColor = App.Color.onBackground
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: App.Color.onBackground]
        UINavigationBar.appearance().isTranslucent = false
        
        viewController.present(tabBarController, animated: true)
    }
    
    func coordinate(to coordinator: CoordinatorProtocol, from viewController: UIViewController) {
        coordinator.start(from: viewController)
    }
}
