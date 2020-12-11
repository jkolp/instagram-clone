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
        COLLECTION_POST.getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            
            // documents.map automatically parses each data into the Post Model. posts variable is now an array. $0 is placeholdeer for each post
            let posts = documents.map({ Post(postId: $0.documentID, dictionary: $0.data())})
            completion(posts)
        }
    }

}
