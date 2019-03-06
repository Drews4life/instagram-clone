//
//  MainTabBarController.swift
//  InstaClone
//
//  Created by Andrii Zakharenkov on 3/2/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginVC = LoginViewController()
                let navController = UINavigationController(rootViewController: loginVC)
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
        
        setupTabNavigation()
       
    }
    
    func setupTabNavigation() {
        let homeVC = setTemplateController(UIImage(named: "home_unselected"), UIImage(named: "home_selected"))
        let searchVC = setTemplateController(UIImage(named: "search_unselected"), UIImage(named: "search_selected"))
        let plusVC = setTemplateController(UIImage(named: "plus_unselected"), UIImage(named: "plus_unselected"))
        let likeVC = setTemplateController(UIImage(named: "like_unselected"), UIImage(named: "like_selected"))
        let userProfileVC = setUserProfileVC()
        
        tabBar.tintColor = .black
        
        viewControllers = [homeVC, searchVC, plusVC, likeVC, userProfileVC]
        
        //tabbar insets
        
        if let items = tabBar.items {
            for item in items {
                item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
            }
        }
    }
    
    fileprivate func setTemplateController(_ unselectedImage: UIImage?, _ selectedImage: UIImage?, _ rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        
        guard let selectedImage = selectedImage else { return UINavigationController() }
        guard let unselectedImage = unselectedImage else { return UINavigationController() }
        
        let homeVC = rootViewController
        
        let navController = UINavigationController(rootViewController: homeVC)
        
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        
        return navController
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.index(of: viewController)
        
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let addPhotoVC = AddPhotoViewController(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: addPhotoVC)
            
            present(navController, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
    
    fileprivate func setUserProfileVC() -> UIViewController {
        let layout = UICollectionViewFlowLayout()
        let userProfileVC = UserProfileViewController(collectionViewLayout: layout)
        
        let navController = UINavigationController(rootViewController: userProfileVC)
        
        navController.tabBarItem.image = UIImage(named: "profile_unselected")
        navController.tabBarItem.selectedImage = UIImage(named: "profile_selected")
        
        return navController
    }
}
