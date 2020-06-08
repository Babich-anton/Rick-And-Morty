//
//  TabCoordinatorProtocol.swift
//  Rick And Morty
//
//  Created by Anton Babich on 09.06.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import UIKit

protocol TabCoordinator {
    
    var rootController: UINavigationController { get }
    var tabBarItem: UITabBarItem { get }
    var storyboard: UIStoryboard { get }
}
