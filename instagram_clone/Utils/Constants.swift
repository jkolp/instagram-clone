//
//  Constants.swift
//  instagram_clone
//
//  Created by Projects on 11/29/20.
//

import FirebaseFirestore

let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_FOLLOWERS = Firestore.firestore().collection("followers")
let COLLECTION_FOLLOWING = Firestore.firestore().collection("following")
let COLLECTION_POST = Firestore.firestore().collection("posts")
