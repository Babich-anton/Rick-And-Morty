//
//  AppSettings.swift
//  Rick And Morty
//
//  Created by Anton Babich on 25.03.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import UIKit

var tabTitlePosition: UIOffset {
    if UIScreen.main.nativeBounds.height > 1500 {
        return UIOffset(horizontal: 0.0, vertical: -4)
    } else {
        return UIOffset(horizontal: 0.0, vertical: -2)
    }
}
