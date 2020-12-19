//
//  PostViewModel.swift
//  instagram_clone
//
//  Created by Projects on 12/10/20.
//  View Model takes stress of computation from view

import Firebase
import UIKit

struct PostViewModel {
    var post: Post
    
    var imageURL : URL? {
        return URL(string: post.imageURL)
    }
    
    var caption: String {
        return post.caption
    }
    
    var likes: Int {
        return post.likes
    }
    
    var userProfileImageURL : URL? { return URL(string: post.ownerImageURL) }
    
    var username: String { return post.ownerUsername }

    var likesLabelText: String {
        if post.likes != 1 {
            return "\(post.likes) Likes"
        } else {
            return "\(post.likes) Like"
        }
    }
    
    var likeButtonImage: UIImage? {
        let imageName = post.didLike ? "like_selected" : "like_unselected"
        return UIImage(named: imageName)
    }
    
    var likeButtonTintColor: UIColor {
        
        return post.didLike ? .red : .black
    }
    
    var timeStamp: Timestamp {
        return post.timestamp
    }
    
    init(post: Post) {
        self.post = post
    }
    
    
}
