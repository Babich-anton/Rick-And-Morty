//
//  ProfileViewController.swift
//  Rick And Morty
//
//  Created by Anton Babich on 19.03.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import Foundation
import FirebaseAuth
import Photos
import RxCocoa
import RxSwift
import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var saveButton: TransitionButton!
    @IBOutlet weak var logoutButton: TransitionButton!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet var imageViewTapper: UITapGestureRecognizer!
    
    var viewModel: ProfileViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = imageView.bounds.midY
        imageView.clipsToBounds = true
        imageView.setNeedsDisplay()
        
        setupBinding()
        setupButtonBinding()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.newPasswordField.rx.text.onNext("")
        self.viewModel.newPasswordViewModel.data.accept("")
        self.confirmPasswordField.rx.text.onNext("")
        self.viewModel.confirmPasswordViewModel.data.accept("")
    }
    
    private func setupBinding() {
        
        self.viewModel.user.subscribe(onNext: { [unowned self] user in
            if let url = user?.photoURL {
                self.imageView.af.setImage(withURL: url) { response in
                    self.imageView.isHidden = false
                    self.indicatorView.stopAnimating()
                }
            }
            
            self.nameField.text = user?.displayName
            self.emailField.text = user?.email
        }).disposed(by: disposeBag)
        
        self.viewModel.isUpdated.subscribe(onNext: { [unowned self] value in
            if self.saveButton.isLoading && value {
                self.saveButton.stopAnimation(animationStyle: .normal, revertAfterDelay: 0.0)
                
                self.newPasswordField.rx.text.onNext("")
                self.viewModel.newPasswordViewModel.data.accept("")
                self.confirmPasswordField.rx.text.onNext("")
                self.viewModel.confirmPasswordViewModel.data.accept("")
            }
        }).disposed(by: disposeBag)
        
        self.nameField.rx.text.orEmpty
            .bind(to: viewModel.nameViewModel.data)
            .disposed(by: disposeBag)
        self.emailField.rx.text.orEmpty
            .bind(to: viewModel.emailViewModel.data)
            .disposed(by: disposeBag)
        self.newPasswordField.rx.text.orEmpty
            .bind(to: viewModel.newPasswordViewModel.data)
            .disposed(by: disposeBag)
        self.confirmPasswordField.rx.text.orEmpty
            .bind(to: viewModel.confirmPasswordViewModel.data)
            .disposed(by: disposeBag)
    }
    
    private func setupButtonBinding() {
        
        self.saveButton.rx.tap.do(onNext: { [unowned self] in
            self.saveButton.startAnimation()
        }).subscribe(onNext: {[unowned self] in
            self.viewModel.update()
        }).disposed(by: disposeBag)
        
        self.logoutButton.rx.tap.do(onNext: { [unowned self] in
            self.logoutButton.startAnimation()
        }).subscribe(onNext: { [unowned self] in
            do {
                try Auth.auth().signOut()
            } catch {
                showMessage(with: error.localizedDescription)
            }
            
            self.logoutButton.stopAnimation(animationStyle: .expand) {
                self.dismiss(animated: false)
            }
        }).disposed(by: disposeBag)
        
        self.imageViewTapper.rx.event.bind(onNext: { tap in
            self.changeUserImage()
        }).disposed(by: disposeBag)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            
            guard let documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return
            }

            let imgPath = documentDirectoryPath.appendingPathComponent("\(Date().timeIntervalSince1970).jpg")

            do {
                try pickedImage.jpegData(compressionQuality: 1)?.write(to: imgPath, options: .atomic)
                self.imageView.af.setImage(withURL: imgPath) { response in
                    self.imageView.isHidden = false
                    self.indicatorView.stopAnimating()
                }
                
                let request = Auth.auth().currentUser?.createProfileChangeRequest()
                request?.photoURL = imgPath
                
                request?.commitChanges { error in
                    if let error = error {
                        showMessage(with: error.localizedDescription)
                    } else {
                        showMessage(with: "User image updated")
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        self.imageView.isHidden = true
        self.indicatorView.startAnimating()
        
        picker.dismiss(animated: true)
    }
    
    private func changeUserImage() {
        let chooseSourceSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let openImageGalleryAction = UIAlertAction(title: "Photos", style: .default) { (action) in
            let status = PHPhotoLibrary.authorizationStatus()
            
            if (status == PHAuthorizationStatus.authorized) {
                self.openGallery()
            } else if (status == PHAuthorizationStatus.denied) {
                self.permissionDenied(message: "Photos is unavailable")
            } else if (status == PHAuthorizationStatus.notDetermined) {
                PHPhotoLibrary.requestAuthorization({ (newStatus) in
                    if (newStatus == PHAuthorizationStatus.authorized) {
                        self.openGallery()
                    } else {
                        self.permissionDenied(message: "Photos is unavailable")
                    }
                })
            } else {
                self.permissionDenied(message: "Photos is unavailable")
            }
        }
        
        let openCameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                self.openCamera()
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.openCamera()
                    } else {
                        self.permissionDenied(message: "Camera is unavailable")
                    }
                }
            case .denied:
                self.permissionDenied(message: "Camera is unavailable")
            case .restricted:
                self.permissionDenied(message: "Camera is unavailable")
            @unknown default: break
            }
        }
        
        chooseSourceSheetController.addAction(openImageGalleryAction)
        chooseSourceSheetController.addAction(openCameraAction)
        chooseSourceSheetController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popoverController = chooseSourceSheetController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.height - 120, width: 0, height: 0)
            popoverController.permittedArrowDirections = .init(rawValue: 0) // remove arrow
        }
        
        present(chooseSourceSheetController, animated: true, completion: nil)
    }
    
    private func openCamera() {
        DispatchQueue.main.async {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.allowsEditing = false
            pickerController.sourceType = .camera
            pickerController.cameraCaptureMode = .photo
            pickerController.showsCameraControls = true
            
            self.present(pickerController, animated: true)
        }
    }
    
    private func openGallery() {
        DispatchQueue.main.async {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.allowsEditing = false
            pickerController.sourceType = .savedPhotosAlbum
            
            self.present(pickerController, animated: true)
        }
    }
    
    func permissionDenied(message: String) {
        DispatchQueue.main.async {
            let cameraAlert = UIAlertController(title: "Permission denied", message: message, preferredStyle: .alert)
            cameraAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(cameraAlert, animated: true, completion: nil)
        }
    }
}
