//
//  PostViewModel.swift
//  instagram_clone
//
//  Created by Projects on 12/10/20.
//  View Model takes stress of computation from view

import Foundation

struct PostViewModel {
    private let post: Post
    
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
    init(post: Post) {
        self.post = post
    }
    
    
}
