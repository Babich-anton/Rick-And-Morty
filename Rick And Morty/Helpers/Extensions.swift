//
//  Extensions.swift
//  Rick And Morty
//
//  Created by Anton Babich on 15.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import Foundation
import MaterialComponents
import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UIViewController {
    
    var viewWillAppear: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.viewWillAppear))
    }
    
    var viewDidAppear: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.viewDidAppear))
    }
    
    var viewWillDisappear: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.viewWillDisappear))
    }
    
    var viewDidDisappear: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.viewDidDisappear))
    }
    
    private func controlEvent(for selector: Selector) -> ControlEvent<Void> {
        return ControlEvent(events: sentMessage(selector).map { _ in })
    }
}

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIStoryboard {
    
    convenience init(_ name: Tab) {
        self.init(name: name.rawValue, bundle: nil)
    }
    
    func inflateVC<T: UIViewController>() -> T {
        if let name = NSStringFromClass(T.self).components(separatedBy: ".").last,
            let vc = instantiateViewController(withIdentifier: name) as? T {
            return vc
        }
        
        fatalError("Could not find " + String(describing: T.self) + ". Perhaps you need to add the class name to the StoryboardID for that UIViewController in IB?")
    }
}

extension UITabBarItem {
    
    convenience init(_ title: Tab, image: Tab) {
        self.init(title: title.rawValue, image: UIImage(named: image.rawValue), selectedImage: UIImage(named: image.rawValue))
    }
}

func showMessage(with text: String) {
    if !text.isEmpty {
        MDCSnackbarManager.show(MDCSnackbarMessage(text: text))
    }
}
