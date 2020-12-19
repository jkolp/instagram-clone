//
//  Post.swift
//  instagram_clone
//
//  Created by Projects on 12/10/20.
//

import Firebase

struct Post {
    var caption: String
    var likes: Int
    let imageURL: String
    let ownerUid: String
    let timestamp: Timestamp // Firebase object. Need to import Firebase
    let postId: String
    let ownerImageURL: String
    let ownerUsername: String
    var didLike = false
    
    init(postId: String, dictionary: [String: Any]) {
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.imageURL = dictionary["imageURL"] as? String ?? ""
        self.ownerUid = dictionary["ownerUid"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.postId = postId
        self.ownerImageURL = dictionary["ownerImageURL"] as? String ?? ""
        self.ownerUsername = dictionary["ownerUsername"] as? String ?? ""
    }
}
