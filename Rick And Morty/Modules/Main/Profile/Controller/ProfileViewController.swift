//
//  ProfileViewController.swift
//  Rick And Morty
//
//  Created by Anton Babich on 19.03.2020.
//  Copyright © 2020 SQILSOFT. All rights reserved.
//

import FirebaseAuth
import RxCocoa
import RxSwift
import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var currentPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    var viewModel: ProfileViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = imageView.bounds.midY
        imageView.clipsToBounds = true
        imageView.setNeedsDisplay()
        
        setupBinding()
    }
    
    private func setupBinding() {
        
        self.viewModel.user.subscribe(onNext: { [unowned self] user in
            if let url = user?.photoURL {
                self.imageView.af.setImage(withURL: url)
            }
            
            self.nameField.text = user?.displayName
            self.emailField.text = user?.email
            self.phoneField.text = user?.phoneNumber
        }).disposed(by: disposeBag)
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        
//        if let user = self.viewModel.user.value {
//            user.displayName = self.nameField.text
//
//        }
//        self.viewModel.update(user: )
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
