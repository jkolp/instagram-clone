//
//  FeedController.swift
//  instagram_clone
//
//  Created by Projects on 11/13/20.
//
// ViewModel is used to create clean code on controller.
// Update of data from view class should be done within its own view using the ViewModel
// Steps
// 1. Grab data from API in a controller class
// 2. Create viewModel for the view that needs data update. Create variable in view file called viewModel.
//    Then, within the controller class, make view_class.viewModel = viewModel // instantiate viewModel from viewController
// 3. In the view class, use didSet { configure() } to automatically update the UI of its view class
// Controller with data -> Instantiate ViewModel for the specific view class -> Make instantiated viewModel to the viewModel type variable in view class. From view class, change data of UI


import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class FeedController: UICollectionViewController {
//When calling from other controlllers : UICollectionView must be initialized with a non-nil layout parameter.
    
// MARK: - Properties
    
    private var posts = [Post]()
    
// MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchPosts()

    }

    
// MARK: - Action
    
    @objc func logout() {
        do {
            try Auth.auth().signOut()
            let controller = LoginController()
            controller.delegate = self.tabBarController as? MainTabController
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        } catch {
            print("DEBUG: Failed to sign out")
        }
    }
    

// MARK: - API
    func fetchPosts() {
        PostService.fetchPosts { posts in
            self.posts = posts
            self.collectionView.reloadData()
        }
    }
    
// MARK: - Helpers

    func configureUI() {
        collectionView.backgroundColor = .white
        
        // Must register cells to collection view
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        
        navigationItem.title = "Feed"
    }
}

// MARK: - UICollectionViewDataSource
// No need to explicitly mention "FeedController : UICollectionViewDataSource" since UICollectionViewDataSource is included in UICollectionViewController
extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Number of items

        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Defines each cell : Content, layout
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.viewModel = PostViewModel(post: posts[indexPath.row])  // By setting viewModel, automatically runs didSet { configure() }
        
        return cell
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
// Sets the size of each cell for the flow layout
extension FeedController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        var height = width + 8 + 40 + 8
        height += 50
        height += 70
        return CGSize(width: width, height: height)
    }
    
}
