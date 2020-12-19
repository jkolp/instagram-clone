//
//  CommentService.swift
//  instagram_clone
//
//  Created by Projects on 12/15/20.
//

import Firebase

struct CommentService {
    
    
    static func uploadComment(comment: String, postID: String, user: User, completion: @escaping(FirestoreCompletion)) {
        
        let data: [String: Any] = ["uid": user.uid,
                                   "comment": comment,
                                   "timestamp": Timestamp(date: Date()),
                                   "username": user.username,
                                   "profileImageUrl": user.profileImageUrl]
        
        COLLECTION_POST.document(postID).collection("comments").addDocument(data: data, completion: completion)
    }
    
    static func fetchComments(forPost postID: String, completion: @escaping([Comments]) -> Void) {
        var comments = [Comments]()
        let query = COLLECTION_POST.document(postID).collection("comments").order(by: "timestamp", descending: true)
        
        query.addSnapshotListener { (snapshot, error) in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let data = change.document.data()
                    let comment = Comments(dictionary: data)
                    comments.append(comment)
                }
            })
            completion(comments)
        }
    }
    
}
