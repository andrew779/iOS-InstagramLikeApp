//
//  NewsFeedTableViewController.swift
//  InstagramLikeApp
//
//  Created by Wenzhong Zheng on 2017-04-11.
//  Copyright © 2017 Wenzhong. All rights reserved.
//

import UIKit
import Firebase

class NewsFeedTableViewController: UITableViewController {

    struct Storyboard {
        static let showWelcome = "ShowWelcomeViewController"
        static let postComposerNVC = "PostComposerNavigationViewController"
    }
    
    var imagePickerHelper: ImagePickerHelper!
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //check wether user logged in
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if let user = user {
                DatabaseReference.users(uid: user.uid).reference().observeSingleEvent(of: .value, with: { (snapshot) in
                    if let userDict = snapshot.value as? [String:Any] {
                        self.currentUser = User(dictionary: userDict)
                        if let tabBarController = self.tabBarController as? TabBarViewController{
                            tabBarController.currentUser = self.currentUser
                            
                        }
                    }
                })
            } else {
                self.performSegue(withIdentifier: Storyboard.showWelcome, sender: nil)
            }
        })
        
        self.tabBarController?.delegate = self
    }

}

extension NewsFeedTableViewController: UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print(viewController.description)
        
        if let _ = viewController as? DummyPostComposerViewController {
            imagePickerHelper = ImagePickerHelper(viewController: self, completion: { (image) in
                
                let postComposerNVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Storyboard.postComposerNVC) as! UINavigationController
                let postComposerVC = postComposerNVC.topViewController as! PostComposerViewController
                
                postComposerVC.image = image
                postComposerVC.currentUser = self.currentUser
                self.present(postComposerNVC, animated: true)
            })
            return false
        }
        return true
    }
}
