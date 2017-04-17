//
//  User.swift
//  InstagramLikeApp
//
//  Created by Wenzhong Zheng on 2017-04-11.
//  Copyright © 2017 Wenzhong. All rights reserved.
//

import Foundation
import Firebase

class User {
    let uid: String
    var username: String
    var fullName: String
    var bio: String
    var website: String
    var profileImage: UIImage?
    
    var follows:[User]
    var followedBy: [User]
    
    // MARK: - Initializers
    init(uid: String, username: String, fullName: String, bio: String, website: String, follows:[User], followedBy: [User], profileImage: UIImage?) {
        self.uid = uid
        self.username = username
        self.fullName = fullName
        self.bio = bio
        self.website = website
        self.follows = follows
        self.followedBy = followedBy
        self.profileImage = profileImage
    }
    
    init(dictionary: [String : Any]) {
        uid = dictionary["uid"] as! String
        username = dictionary["username"] as! String
        fullName = dictionary["fullName"] as! String
        bio = dictionary["bio"] as! String
        website = dictionary["website"] as! String
        
        //follows
        self.follows = []
        if let followsDic = dictionary["follows"] as? [String : Any] {
            for (_, userDic) in followsDic {
                if let userDic = userDic as? [String : Any] {
                    self.follows.append(User(dictionary: userDic))
                }
            }
        }
        
        // followedBy
        self.followedBy = []
        if let followedByDic = dictionary["followedBy"] as? [String: Any] {
            for (_, userDict) in followedByDic {
                if let userDict = userDict as? [String : Any]{
                    self.followedBy.append(User(dictionary: userDict))
                }
            }
        }
    }
    
    func save(completion: @escaping (Error?) -> Void) {
        let ref = DatabaseReference.users(uid: uid).reference()
        ref.setValue(toDictionary())
        
        //save follows
        for user in follows {
            ref.child("follows/\(user.uid)").setValue(user.toDictionary())
        }
        //save followed by
        for user in followedBy {
            ref.child("followedBy/\(user.uid)").setValue(user.toDictionary())
        }
        //save profileImage
        if let profileImage = self.profileImage {
            let firImage = FIRImage(image: profileImage)
            firImage.saveProfileImage(self.uid, { (error) in
                completion(error)
            })
        }
        
    }
    
    func toDictionary() -> [String : Any] {
        return [
            "uid" : uid,
            "username" : username,
            "fullName" : fullName,
            "bio" : bio,
            "website" : website
        ]
    }
}

extension User {
    func share(newMedia: Media){
        DatabaseReference.users(uid: uid).reference().child("media").childByAutoId().setValue(newMedia.uid)
    }
}
