//
//  ProfileImageProtocol.swift
//  Rick And Morty
//
//  Created by Anton Babich on 12.07.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

import UIKit

protocol ProfileImageProtocol: class {
    
    var galleryAction: UIAlertAction { get }
    
    var cameraAction: UIAlertAction { get }
    
    func changeUserImage()
    
    func openCamera()
    
    func openGallery()
    
    func showPermissionDeniedAlert(with message: String)
}
