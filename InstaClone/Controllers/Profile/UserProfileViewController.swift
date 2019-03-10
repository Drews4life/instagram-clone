//
//  UserProfileViewController.swift
//  InstaClone
//
//  Created by Andrii Zakharenkov on 3/2/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit
import Firebase

class UserProfileViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private var user: User?
    private var posts = [UserPost]()
    
    var userId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        fetchUser()
        
        collectionView.register(UserHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
        collectionView.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: USER_PROFILE_PHOTO_CELL)
        
        setupLogoutBtn()
    }
    
    fileprivate func loadNewUserPost(forUid uid: String) {
        Database
            .postsRef()
            .child(uid)
            .queryOrdered(byChild: "creationDate")
            .observe(.childAdded, with: { (snapshot) in
                guard let postDictionary = snapshot.value as? [String : Any] else { return }
                
                guard let user = self.user else { return }
                let post = UserPost(user: user, dictionary: postDictionary)
                self.posts.insert(post, at: 0)
                self.collectionView.reloadData()
                
        }) { (error) in
                debugPrint("Could not append child: \(error.localizedDescription)")
        }
    }
    
    
    fileprivate func setupLogoutBtn() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.handleLogout))
        
    }
    
    @objc func handleLogout() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { (_) in
            do {
                try Auth.auth().signOut()
    
                let loginController = LoginViewController()
                let navController = UINavigationController(rootViewController: loginController)
                
                self.present(navController, animated: true, completion: nil)
            } catch {
                debugPrint("Unable to log out: \(error.localizedDescription)")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserHeader
   
        header.user = self.user
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: USER_PROFILE_PHOTO_CELL, for: indexPath) as? UserProfilePhotoCell else { return UserProfilePhotoCell() }
        
        cell.post = posts[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        
        return CGSize(width: width, height: width)
    }
    
    fileprivate func fetchUser() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let uidToSearch = userId ?? uid
        
        Database.fetchUser(withUid: uidToSearch) { (success, user) in
            if success {
                guard let user = user else { return }
                
                self.user = user
                self.navigationItem.title = user.username
                self.collectionView.reloadData()
                
                self.loadNewUserPost(forUid: uidToSearch)
            }
        }
    }
}
