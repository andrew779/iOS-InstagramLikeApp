//
//  PostComposerViewController.swift
//  InstagramLikeApp
//
//  Created by Wenzhong Zheng on 2017-04-15.
//  Copyright © 2017 Wenzhong. All rights reserved.
//

import UIKit

class PostComposerViewController: UITableViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var shareBarButton: UIBarButtonItem!
    
    var image: UIImage!
    var imagePickerSourceType: UIImagePickerControllerSourceType!
    var test:String?
    var currentUser:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.becomeFirstResponder()
        textView.text = ""
        textView.delegate = self
        
        shareBarButton.isEnabled = false
        imageView.image = self.image
        
        tableView.allowsSelection = false
        
    }
    
    @IBAction func cancelDidTap() {
        self.image = nil
        self.imageView.image = nil
        textView.resignFirstResponder()
        textView.text = ""
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareDidTap(_ sender: Any) {
        if let image = image, let caption = textView.text,let currentUser = currentUser {
            let newMedia = Media(type: "image", caption: caption, createdBy: currentUser, image: image)
            newMedia.save(completion: { (error) in
                if let error = error {
                    self.alert(title: "Oops", message: error.localizedDescription, buttonTitle: "OK")
                } else {
                    currentUser.share(newMedia: newMedia)
                }
            })
        }
        self.cancelDidTap()
    }
    
    func alert(title: String, message: String, buttonTitle: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
}

extension PostComposerViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        shareBarButton.isEnabled = textView.text != ""
         
    }
}
