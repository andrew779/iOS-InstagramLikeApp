//
//  TabBarViewController.swift
//  InstagramLikeApp
//
//  Created by Wenzhong Zheng on 2017-04-15.
//  Copyright © 2017 Wenzhong. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    var currentUser:User?
    let postComposerNVC = "PostComposerNavigationViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.delegate = self
    }
    
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    
//                if let _ = viewController as? DummyPostComposerViewController {
//                    _ = ImagePickerHelper(viewController: self, completion: { (image) in
//        
//                        let postComposerNVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: self.postComposerNVC) as! UINavigationController
//                        let postComposerVC = postComposerNVC.topViewController as! PostComposerViewController
//        
//                        postComposerVC.image = image
//                        self.present(postComposerNVC, animated: true)
//                    })
//                    return false
//                }
//                return true
        
//        if let cameraNVC = viewController as? CameraNavigationViewController {
//            _ = ImagePickerHelper(viewController: self, completion: { (image) in
//                
//                let viewController = cameraNVC.topViewController as! PostComposerViewController
//                viewController.image = image
////                self.present(cameraNVC, animated: true, completion: nil)
//            })
//            return true
//        }
//        return true
//    }
    
    
}
