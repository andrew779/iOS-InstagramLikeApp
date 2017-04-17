//
//  File.swift
//  InstagramLikeApp
//
//  Created by Wenzhong Zheng on 2017-04-15.
//  Copyright © 2017 Wenzhong. All rights reserved.
//

import UIKit
import Firebase

class Media {
    var uid: String
    let type: String
    var caption: String
    var createdTime: Double
    var createdBy: User
    var likes: [User]
    var comments: [Comment]
    var mediaImage: UIImage!
    
    init(type: String, caption: String, createdBy: User, image: UIImage){
        self.type = type
        self.caption = caption
        self.createdBy = createdBy
        self.mediaImage = image
        
        createdTime = Date().timeIntervalSince1970
        comments = []
        likes = []
        uid = DatabaseReference.media.reference().childByAutoId().key
    }
    
    func save(completion: @escaping (Error?) -> Void) {
        let ref = DatabaseReference.media.reference().child(uid)
        ref.setValue(toDictionary())
        // Save likes
        for like in likes {
            ref.child("likes/\(like.uid)").setValue(like.toDictionary())
        }
        // save comments
        for comment in comments {
            ref.child("comments/\(comment.uid)").setValue(comment.toDictionary())
        }
        
        //save Image to storage database
        let firImage = FIRImage(image: mediaImage)
        firImage.save(self.uid) { (error) in
            completion(error)
        }
    }
    
    func toDictionary() -> [String:Any] {
        return [
            "uid" : uid,
            "type" : type,
            "caption" : caption,
            "createdTime" : createdTime,
            "createdBy" : createdBy.toDictionary()
        ]
    }
}

extension Media {
    func downloadMediaImage(completion: @escaping (UIImage?, Error?) -> Void) {
        FIRImage.downloadImage(uid: uid) { (image, error) in
            completion(image, error)
        }
    }
}

class Comment {
    var mediaUID: String
    var uid: String
    var createdTime: Double
    var from: User
    var caption: String
    var ref: FIRDatabaseReference
    
    init(mediaUID: String, from: User, caption: String) {
        self.mediaUID = mediaUID
        self.from = from
        self.caption = caption
        
        self.createdTime = Date().timeIntervalSince1970
        
        
        ref = DatabaseReference.media.reference().child("\(mediaUID)/comments").childByAutoId()
        
        uid = ref.key
    }
    
    init(dictionary:[String: Any]){
        self.uid = dictionary["uid"] as! String
        self.createdTime = dictionary["createdTime"] as! Double
        self.caption = dictionary["caption"] as! String
        
        let fromDictionary = dictionary["from"] as! [String:Any]
        from = User(dictionary: fromDictionary)
        
        mediaUID = dictionary["mediaUID"] as! String
        ref = DatabaseReference.media.reference().child("\(mediaUID)/comments/\(uid)")
    }
    
    func save() {
        ref.setValue(toDictionary())
    }
    
    func toDictionary() -> [String:Any] {
        return [
            "mediaUID" : mediaUID,
            "uid" : uid,
            "createdTime" : createdTime,
            "from" : from.toDictionary(),
            "caption" : caption
        ]
    }
}
