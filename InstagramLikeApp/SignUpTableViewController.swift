//
//  SignUpTableViewController.swift
//  InstagramLikeApp
//
//  Created by Wenzhong Zheng on 2017-04-11.
//  Copyright © 2017 Wenzhong. All rights reserved.
//

import UIKit
import Firebase

class SignUpTableViewController: UITableViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var imagePickerHelper: ImagePickerHelper!
    var profileImage: UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
        profileImageView.layer.masksToBounds = true
        
        emailTextField.delegate = self
        fullNameTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
    }

    @IBAction func createNewAccountDidTap() {
        // create new account
        // save the user data, take a photo
        // login the user
        if emailTextField.text != ""
            && (passwordTextField.text?.characters.count)! > 5
            && (usernameTextField.text?.characters.count)! > 5
            && profileImage != nil {
            
            let username = usernameTextField.text!
            let fullName = fullNameTextField.text!
            let email = emailTextField.text!
            let password = passwordTextField.text!
            
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                if let error = error {
                    self.showErrorAlert(msg: error)
                    return
                } else if let user = user {
                    let newUser = User(uid: user.uid, username: username, fullName: fullName, bio: "", website: "", follows: [], followedBy: [], profileImage: self.profileImage)
                    newUser.save(completion: { (error) in
                        if let error = error {
                            self.showErrorAlert(msg: error)
                            return
                        } else {
                            // Login
                            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                                if let error = error {
                                    self.showErrorAlert(msg: error)
                                } else {
                                    self.dismiss(animated: true, completion: nil)
                                }
                            })
                        }
                    })
                }
            })
        }
    }
    
    func showErrorAlert(msg: Error){
        let alert = UIAlertController(title: "Error", message: msg.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)

    }
    
    @IBAction func changeProfilePhotoDidTap(_ sender: UIButton) {
        imagePickerHelper = ImagePickerHelper(viewController: self, completion: { (image) in
            self.profileImageView.image = image
            self.profileImage = image
        })
    }
    
    @IBAction func backDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension SignUpTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            fullNameTextField.becomeFirstResponder()
        } else if textField == fullNameTextField {
            usernameTextField.becomeFirstResponder()
        } else if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
            createNewAccountDidTap()
        }
        return true
    }
}
