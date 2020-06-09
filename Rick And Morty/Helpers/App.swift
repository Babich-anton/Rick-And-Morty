//
//  AppColor.swift
//  Rick And Morty
//
//  Created by Anton Babich on 10.06.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import UIKit

struct App {
    
    struct Color {
        static var background: UIColor { return UIColor(hex: 0x121212) }
        static var error: UIColor { return UIColor(hex: 0xCF6679) }
        static var onBackground: UIColor { return UIColor(hex: 0xFFFFFF) }
        static var onError: UIColor { return UIColor(hex: 0x000000) }
        static var onPrimary: UIColor { return UIColor(hex: 0x000000) }
        static var primaryVariant: UIColor { return UIColor(hex: 0x3700B3) }
        static var primary: UIColor { return UIColor(hex: 0xBB86FC) }
        static var secondary: UIColor { return UIColor(hex: 0x03DAC6) }
        static var surface: UIColor { return UIColor(hex: 0x353535) }
    }
    
    enum Tab: String {
        
        case character = "Character"
        case location  = "Location"
        case episodes  = "Episodes"
        case profile   = "Profile"
        
        var cellIdentifier: String {
            switch self {
            case .character:
                return "character-cell"
            case .location:
                return "location-cell"
            case .episodes:
                return "episode-cell"
            case .profile:
                return ""
            }
        }
        
        var cellNib: String {
            switch self {
            case .character:
                return "CharacterViewCell"
            case .location:
                return "LocationViewCell"
            case .episodes:
                return "EpisodeViewCell"
            case .profile:
                return ""
            }
        }
    }
}
