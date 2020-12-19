//
//  ProfileController.swift
//  instagram_clone
//
//  Created by Projects on 11/13/20.
//

import UIKit

private let cellIdentifier = "ProfileCell"
private let headerIdentifier = "ProfileHeader"

class ProfileController: UICollectionViewController {
    
    // MARK: - Properties
    private var user: User
    private var posts = [Post]()
    
//    private var user: User {
//        // user variable is not set until fetchUser() is called.
//        // Since user is set to nil, user will be set, then didSet {} will run
//        // didSet observer
//        didSet { collectionView.reloadData() }
//    }
//
    
    // MARK: - Lifecycle
    
    init (user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        checkIfUserIsFollowed()
        fetchUserStats()
        fetchPosts()
    }

    
    // MARK: - API
    
    func fetchUser() {
        UserService.fetchUser(withUid: user.uid) { user in
            self.user = user
            //self.navigationItem.title = user.username
        }
    }
    
    func checkIfUserIsFollowed() {
        UserService.checkIfUserIsFollowed(uid: user.uid, completion: { isFollowed in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
                                           
        })
    }
    
    func fetchUserStats() {
        UserService.fetchUserStats(uid: user.uid) { (stats) in
            self.user.stats = stats
            self.collectionView.reloadData()
            
            
        }
    }
    
    func fetchPosts() {
        PostService.fetchPosts(forUser: user.uid) { (posts) in
            self.posts = posts
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Helpers
    
    func configureCollectionView(){
        navigationItem.title = user.username
        collectionView.backgroundColor = .white
        // Creating Cells: Registers a class for use in creating new collection view cells.
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: cellIdentifier)
        // Creating Header: Registers a class for use in creating supplementary views for the collection view.
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
}

// MARK: - UICollectionViewDataSource
extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // returning cell
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProfileCell
        cell.viewModel = PostViewModel(post: posts[indexPath.row])
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // returning header. Initializing header's viewModel object for didSet observer
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        
        header.delegate = self
        
        // ViewModels are used for information to be transferred over to another ViewController
        header.viewModel = ProfileHeaderViewModel(user: user)
        
        
        
        
        return header
    }
}

// MARK: - UICollectionViewDelegate
extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // action to take when selecting one of the images listed in Profile controller
        print("DEBUG: POST IS \(posts[indexPath.row].caption)")
        
        let controller = FeedController(collectionViewLayout: UICollectionViewFlowLayout()) // initialization is necessary
        controller.post = posts[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileController: UICollectionViewDelegateFlowLayout{
    // Decides spacing between each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        // spacing left and right
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // spacing top and bottom
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // size of each cell
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // size of header
        return CGSize(width: view.frame.width, height: 240)
    }
}


extension ProfileController: ProfileHeaderDelegate {
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User) {
        if user.isCurrentUser {
            print("DEBUG: Show edit profile here..")
        } else if user.isFollowed {
            UserService.unfollow(uid: user.uid) { (error) in
                self.user.isFollowed = false
                self.collectionView.reloadData()
            }
        } else {
            UserService.follow(uid: user.uid) { (error) in
                self.user.isFollowed = true
                self.collectionView.reloadData()
            }
        }
    }
    

}
