//
//  ImagePickerHelper.swift
//  InstagramLikeApp
//
//  Created by Wenzhong Zheng on 2017-04-11.
//  Copyright © 2017 Wenzhong. All rights reserved.
//

import UIKit
import MobileCoreServices

typealias ImagePickerHelperCompletion = ((UIImage?) -> Void)!

class ImagePickerHelper: NSObject {
    
    // actionsheet, imagePickerController ==> viewController
    weak var viewController: UIViewController!
    var completion:ImagePickerHelperCompletion
    
    init(viewController:UIViewController, completion: ImagePickerHelperCompletion) {
        self.viewController = viewController
        self.completion = completion
        super.init()
        
        self.showPhotoSourceSelection()
    }
    
    func showPhotoSourceSelection(){
        let actionSheet = UIAlertController(title: "Picker New Photo", message: "Would you like to open photos library or camera", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.showImagePicker(sourceType: .camera)
        }
        let photosLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.showImagePicker(sourceType: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
            print("OK, Canceled")
        })
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(photosLibraryAction)
        actionSheet.addAction(cancelAction)
        
        viewController.present(actionSheet, animated: true, completion: nil)
    }
    
    func showImagePicker(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = sourceType
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.delegate = self
        
        viewController.present(imagePicker, animated: true, completion: nil)
    }
}

extension ImagePickerHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var myImage:UIImage?
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            myImage = image
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            myImage = image
        } else {
            myImage = nil
        }
//        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        viewController.dismiss(animated: true, completion: nil)
        completion(myImage)
    }
}


