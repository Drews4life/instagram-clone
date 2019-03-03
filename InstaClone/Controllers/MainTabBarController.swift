//
//  MainTabBarController.swift
//  InstaClone
//
//  Created by Andrii Zakharenkov on 3/2/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainTabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil {
        
            DispatchQueue.main.async {
                let loginVC = LoginViewController()
                let navController = UINavigationController(rootViewController: loginVC)
                self.present(navController, animated: true, completion: nil)
            }
            
            return
        }
        
        let layout = UICollectionViewFlowLayout()
        let userProfileVC = UserProfileViewController(collectionViewLayout: layout)
        
        let navController = UINavigationController(rootViewController: userProfileVC)
        
        navController.tabBarItem.image = UIImage(named: "profile_unselected")
        navController.tabBarItem.selectedImage = UIImage(named: "profile_selected")
        
        tabBar.tintColor = .black
        
        viewControllers = [navController, UIViewController()]
    }
    
}
