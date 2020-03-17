//
//  AppDelegate.swift
//  Rick And Morty
//
//  Created by Anton Babich on 14.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        IQKeyboardManager.shared().isEnabled = true
        
        return true
    }
}
