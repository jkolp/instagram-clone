//
//  MainTabController.swift
//  instagram_clone
//
//  Created by Projects on 11/13/20.
//

import UIKit
import Firebase
import YPImagePicker

class MainTabController : UITabBarController {
    
    
// MARK: - Lifecycle
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            configureViewControllers(withUser: user)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //logout()
        checkIfUserIsLoggedIn()
        fetchUser()
        tabBarController?.selectedIndex = 3
    }
    
    
// MARK: - API
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginController()
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
            
        }
    }
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.fetchUser(withUid: uid) { user in
            self.user = user
            self.navigationItem.title = user.username
        }
    }
    
// MARK: - Helpers
    
    func configureViewControllers(withUser user: User) {
        view.backgroundColor = .white
        self.delegate = self
        let layout = UICollectionViewFlowLayout() //UICollectionView must be initialized with a non-nil layout parameter. For example : UICollectionViewFlowLayout
        let feed = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: FeedController(collectionViewLayout: layout))
        
        let search = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: SearchController())
        
        let imageSelector = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"), rootViewController: ImageSelectorController())
        
        let notifications = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"), rootViewController: NotificationController())
        
        let profileController = ProfileController(user: user)
        let profile = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: profileController)
        
        // An array of the root view controllers displayed by the tab bar interface.
        // When configuring a tab bar controller, you can use this property to specify the content for each tab of the tab bar interface. The order of the view controllers in the array corresponds to the display order in the tab bar.
        // Use viewControllers to configure tab bar controller including tab bar interface.
        viewControllers = [feed, search, imageSelector, notifications, profile]
        
        tabBar.tintColor = .black
    }
    
    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        // Customize tab bar item image, tintColo, and etc
        // .tabBarItem is only used when the view controller is a child of a tab bar controller
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        
        return nav
    }
    
    func didFinishPickingMedia(_ picker: YPImagePicker) {
        picker.didFinishPicking { items, _ in
            picker.dismiss(animated: false) {
                guard let selectedImage = items.singlePhoto?.image else { return }
                
                let controller = UploadPostController()
                controller.selectedImage = selectedImage
                controller.delegate = self
                controller.currentUser = self.user
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: false, completion: nil)
            }
        }
    }
}

    

// MARK: - Authentication Delegate
extension MainTabController: AuthenticationDelegate {
    func authenticationDidComplete() {
        print("DEBUG : Auth did complete. Fetch user and update here...")
        fetchUser()
        self.dismiss(animated: true, completion: nil)
    }
}


// MARK: - UITabBarControllerDelegate
extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // selected view controllers is passed in as "viewController" parameter
        let index = viewControllers?.firstIndex(of: viewController) // This finds the first index of the corresponding viewcontroller
        
        if index == 2 {
            var config = YPImagePickerConfiguration()
            config.library.mediaType = .photo
            config.shouldSaveNewPicturesToAlbum = false //save picture to the personal camera roll or not
            config.startOnScreen = .library
            config.screens = [.library]
            config.hidesStatusBar = false
            config.hidesBottomBar = false
            config.library.maxNumberOfItems = 1
            
            let picker = YPImagePicker(configuration: config)
            picker.modalPresentationStyle
                = .fullScreen
            present(picker, animated: true, completion: nil)
            
            didFinishPickingMedia(picker)
        }
        return true
    }
}

extension MainTabController: UploadPostControllerDelegate {
    // This function is ran after didTapDoneButton from uploadPostController
    func controllerDidFinishUploadingPost(_ controller: UploadPostController) {
        selectedIndex = 0   // sets the currently selected tab bar index
        controller.dismiss(animated: true, completion: nil)
        
        // refresh feed controller after posting
        // since FeedController is the root of UINavigationController, first get the UINavigationController
        // holding the feed controller.
        // Then, get the feed object from the UINavigationController stack as showen in the second guard
        guard let feedNav = viewControllers?.first as? UINavigationController else { return }
        guard let feed = feedNav.viewControllers.first as? FeedController else { return }
        feed.handleRefresh()
    }
}
