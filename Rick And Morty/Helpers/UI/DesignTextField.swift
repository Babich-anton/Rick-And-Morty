//
//  DesignTextField.swift
//  Rick And Morty
//
//  Created by Anton Babich on 17.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable open class DesignTextField : UITextField {
    
    /// the color for placeholder text
    @IBInspectable open var placeholderBackgroundColor: UIColor = UIColor.lightGray {
        didSet {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: placeholderBackgroundColor.withAlphaComponent(0.4)])
        }
    }
    
    /// the corner radius value to have a text field with rounded corners.
    @IBInspectable open var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
}
