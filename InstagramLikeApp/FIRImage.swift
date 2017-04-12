//
//  FIRImage.swift
//  InstagramLikeApp
//
//  Created by Wenzhong Zheng on 2017-04-11.
//  Copyright © 2017 Wenzhong. All rights reserved.
//

import Foundation
import Firebase

class FIRImage {
    var image: UIImage
    var downloadURL: URL?
    var downloadLink: String!
    var ref: FIRStorageReference!
    
    init(image: UIImage) {
        self.image = image
    }
}

extension FIRImage
{
    func saveProfileImage(_ userUID: String, _ completion: @escaping (Error?) -> Void) {
        let resizedImage = image.resized()
        let imageData = UIImageJPEGRepresentation(resizedImage, 0.9)
        
        ref = StorageReference.profileImages.reference().child(userUID)
        downloadLink = ref.description
        
        ref.put(imageData!, metadata: nil) { (metaData, error) in
            completion(error)
        }
    }
    
    func save(_ uid: String, completion: @escaping (Error?) -> Void) {
        let resizedImage = image.resized()
        let imageData = UIImageJPEGRepresentation(resizedImage, 0.9)
        
        ref = StorageReference.images.reference().child(uid)
        downloadLink = ref.description
        
        ref.put(imageData!, metadata: nil) { (metaData, error) in
            completion(error)
        }
    }
}

extension FIRImage {
    class func downloadProfileImage(_ uid: String, completion: @escaping (UIImage?, Error?) -> Void) {
        StorageReference.profileImages.reference().child(uid).data(withMaxSize: 1 * 1024 * 1024) { (imageData, error) in
            if let error = error {
                completion(nil,error)
                return
            }
            
            let image = UIImage(data: imageData!)
            completion(image,error)
        }
    }
    
    class func downloadImage(uid: String, completion: @escaping (UIImage?, Error?) -> Void ){
        StorageReference.images.reference().child(uid).data(withMaxSize: 1 * 1024 * 1024) { (imageData, error) in
            if let error = error {
                completion(nil,error)
                return
            }
            
            let image = UIImage(data: imageData!)
            completion(image,error)
        }
    }
}

private extension UIImage {
    func resized() -> UIImage {
        let height: CGFloat = 800.0
        let ratio = self.size.width / self.size.height
        let width = height * ratio
        
        let newSize = CGSize(width: width, height: height)
        let newRectangle = CGRect(x: 0, y: 0, width: width, height: height)
        
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: newRectangle)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage!
    }
}
