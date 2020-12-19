//
//  Comments.swift
//  instagram_clone
//
//  Created by Projects on 12/17/20.
//

import Firebase

struct Comments {
    let uid: String
    let username: String
    let profileImageUrl: String
    let timestamp: Timestamp
    let commentText: String
    
    init(dictionary: [String: Any]){
        self.uid  = dictionary["uid"] as? String ?? ""
        self.username  = dictionary["username"] as? String ?? ""
        self.profileImageUrl  = dictionary["profileImageUrl"] as? String ?? ""
        self.commentText = dictionary["comment"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}
