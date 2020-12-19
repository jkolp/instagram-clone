//
//  PostService.swift
//  instagram_clone
//
//  Created by Projects on 12/10/20.
//

import UIKit
import Firebase

struct PostService {
    // Upload post to firestore
    static func uploadPost(caption: String, image: UIImage, user: User, completion: @escaping (FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ImageUploader.uploadImage(image: image) { (imageURL) in
            let data = ["caption": caption,
                        "timestamp": Timestamp(date: Date()),
                        "likes": 0,
                        "imageURL": imageURL,
                        "ownerUid": uid,
                        "ownerImageURL": user.profileImageUrl,
                        "ownerUsername": user.username]  as [String : Any]
            // [String: Any] is needed because data contains various types of data
            
            COLLECTION_POST.addDocument(data: data, completion: completion)
            
        }
    }
    
    static func fetchPosts(completion: @escaping([Post]) -> Void) {
        COLLECTION_POST.order(by: "timestamp", descending: true).getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            
            // documents.map automatically parses each data into the Post Model. posts variable is now an array. $0 is placeholdeer for each post
            let posts = documents.map({ Post(postId: $0.documentID, dictionary: $0.data())})
            completion(posts)
        }
    }

    static func fetchPosts(forUser uid: String, completion: @escaping([Post]) -> Void) {
        let query = COLLECTION_POST.whereField("ownerUid", isEqualTo: uid)
            //.order(by: "timestamp", descending: true)
        
        query.getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            

            var posts = documents.map({ Post(postId: $0.documentID, dictionary: $0.data()) })
            posts.sort{ (post1, post2) -> Bool in
                // sorts by latest first
                return post1.timestamp.seconds > post2.timestamp.seconds
            }
            
            completion(posts)
            
        }
    }
    
    
    static func likePost(post: Post, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // Updating post likes and user likes. Setting empty dictionary since we just want the count of documents with no fields.
        
        COLLECTION_POST.document(post.postId).updateData(["likes": post.likes + 1])
        
        COLLECTION_POST.document(post.postId).collection("post-likes").document(uid).setData([:]) { _ in
            
            COLLECTION_USERS.document(uid).collection("uesr-likes").document(post.postId).setData([:], completion: completion)
        }
    }
    
    static func unlikePost(post: Post, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard post.likes > 0 else { return } // Only unlike post if post.likes is greater than 0
        
        COLLECTION_POST.document(post.postId).updateData(["likes" : post.likes - 1])
        
        COLLECTION_POST.document(post.postId).collection("post-likes").document(uid).delete { error in
            COLLECTION_USERS.document(uid).collection("user-likes").document(post.postId).delete(completion: completion)
        }
    }
    
    static func checkIfUserLikedPost(post: Post, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_USERS.document(uid).collection("user-likes").document(post.postId).getDocument { (snapshot, error) in
            if let error = error {
                print("DEBUG : \(error.localizedDescription)")
            } else {
                guard let didLike = snapshot?.exists else { return }
                completion(didLike)
            }
        }
    }
}
