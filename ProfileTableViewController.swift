//
//  ProfileTableViewController.swift
//  InstagramLikeApp
//
//  Created by Wenzhong Zheng on 2017-04-12.
//  Copyright © 2017 Wenzhong. All rights reserved.
//

import UIKit
import Firebase

class ProfileTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func logOutDidTap(_ sender: Any) {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let error {
            print(error)
        }
        
        self.tabBarController?.selectedIndex = 0
    }
    
}
