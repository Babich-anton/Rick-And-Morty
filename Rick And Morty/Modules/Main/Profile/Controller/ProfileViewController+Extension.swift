//
//  ProfileViewController+Extension.swift
//  Rick And Morty
//
//  Created by Anton Babich on 12.07.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import Photos
import UIKit

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, ProfileImageProtocol {
    
    var galleryAction: UIAlertAction {
        UIAlertAction(title: "Photos", style: .default) { _ in
            let status = PHPhotoLibrary.authorizationStatus()
            
            switch status {
            case PHAuthorizationStatus.authorized:
                self.openGallery()
            case PHAuthorizationStatus.denied:
                self.showPermissionDeniedAlert(with: "Photos is unavailable")
            case PHAuthorizationStatus.notDetermined:
                PHPhotoLibrary.requestAuthorization({ (newStatus) in
                    if newStatus == .authorized {
                        self.openGallery()
                    } else {
                        self.showPermissionDeniedAlert(with: "Photos is unavailable")
                    }
                })
            default:
                 self.showPermissionDeniedAlert(with: "Photos is unavailable")
            }
        }
    }
    
    var cameraAction: UIAlertAction {
        UIAlertAction(title: "Camera", style: .default) { _ in
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                self.openCamera()
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.openCamera()
                    } else {
                        self.showPermissionDeniedAlert(with: "Camera is unavailable")
                    }
                }
            case .denied:
                self.showPermissionDeniedAlert(with: "Camera is unavailable")
            case .restricted:
                self.showPermissionDeniedAlert(with: "Camera is unavailable")
            @unknown default: break
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            
            guard let documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return
            }

            let imgPath = documentDirectoryPath.appendingPathComponent("user-image.jpg")

            do {
                try pickedImage.jpegData(compressionQuality: 1)?.write(to: imgPath, options: .atomic)
                
                self.imageView.af.setImage(withURL: imgPath) { _ in
                    self.imageView.isHidden = false
                    self.indicatorView.stopAnimating()
                }
                
                FirebaseManager.update(image: imgPath, successHandler: {
                    showMessage(with: "User image updated")
                }, errorHandler: { error in
                    showMessage(with: error.localizedDescription)
                })
            } catch {
                print(error.localizedDescription)
            }
        }
        
        self.imageView.isHidden = true
        self.indicatorView.startAnimating()
        
        picker.dismiss(animated: true)
    }
    
    func changeUserImage() {
        let chooseSourceSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        chooseSourceSheetController.addAction(galleryAction)
        chooseSourceSheetController.addAction(cameraAction)
        chooseSourceSheetController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popoverController = chooseSourceSheetController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.height - 120, width: 0, height: 0)
            popoverController.permittedArrowDirections = .init(rawValue: 0) // remove arrow
        }
        
        present(chooseSourceSheetController, animated: true, completion: nil)
    }
    
    func openCamera() {
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
    
    func openGallery() {
        DispatchQueue.main.async {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.allowsEditing = false
            pickerController.sourceType = .savedPhotosAlbum
            
            self.present(pickerController, animated: true)
        }
    }
    
    func showPermissionDeniedAlert(with message: String) {
        DispatchQueue.main.async {
            let cameraAlert = UIAlertController(title: "Permission denied", message: message, preferredStyle: .alert)
            cameraAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(cameraAlert, animated: true, completion: nil)
        }
    }
}
