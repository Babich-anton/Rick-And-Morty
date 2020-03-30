//
//  AppDelegate.swift
//  Rick And Morty
//
//  Created by Anton Babich on 14.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import Firebase
import IQKeyboardManager
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        IQKeyboardManager.shared().isEnabled = true
        
        window = UIWindow()
        window?.rootViewController = UIViewController()
        
        if let vc = window?.rootViewController {
            AppCoordinator().start(from: vc)
        }
        
        window?.makeKeyAndVisible()
        
        return true
    }
}
