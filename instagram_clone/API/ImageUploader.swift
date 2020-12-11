//
//  ImageUploader.swift
//  instagram_clone
//
//  Created by Projects on 11/24/20.
//

import FirebaseStorage

struct ImageUploader {
    // To save profile images,
    // 1. Save to storage first
    // 2. Then save the imageURL in the storage with user's credential under Auth.auth().create
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Failed to upload image \(error.localizedDescription)")
            }
            
            // Need downloadURL to download user's profile to the app
            ref.downloadURL { (url, error) in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
}
