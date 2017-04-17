//
//  WelcomeViewController.swift
//  InstagramLikeApp
//
//  Created by Wenzhong Zheng on 2017-04-11.
//  Copyright © 2017 Wenzhong. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if let user = user {
                self.dismiss(animated: false, completion: nil)
            } else{
                print("no user logged in yet")
            }
        })
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func test(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
