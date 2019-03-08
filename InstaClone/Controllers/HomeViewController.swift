//
//  HomeViewController.swift
//  InstaClone
//
//  Created by Andrii Zakharenkov on 3/8/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let postsRef = Database.database().reference().child("posts")
    private let usersRef = Database.database().reference().child("users")
    
    private var posts = [UserPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        collectionView.backgroundColor = .white
        collectionView.register(FeedPostCell.self, forCellWithReuseIdentifier: FEED_POST_CELL)
        
        setupNavBar()
        fetchFeedPosts()
    }
    
    fileprivate func setupNavBar() {
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo2")?.withRenderingMode(.alwaysOriginal))
    }
    
    fileprivate func fetchFeedPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.fetchUser(withUid: uid) { (success, user) in
            if !success {
                debugPrint("Unable to fetch user")
            } else {
                guard let user = user else { return }
                self.getAllPosts(user: user)
            }
        }
    }
    
    fileprivate func getAllPosts(user: User) {
        self.postsRef
            .child(user.uid)
            .queryOrdered(byChild: "creationDate")
            .observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let snapDictionary = snapshot.value as? [String : Any] else { return }
                
                snapDictionary.forEach({ (key, value) in
                    guard let dictionary = value as? [String : Any] else { return }
                    
                    
                    let post = UserPost(user: user, dictionary: dictionary)
                    self.posts.append(post)
                })
                
                self.collectionView.reloadData()
                
            }) { (error) in
                debugPrint("Unable to fetch all feed posts: \(error.localizedDescription)")
        }
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        
        //40 profile image size
        //8 + 8 - paddings
        //50 action stack size
        //60 captionview size
        let height = 40 + 8 + 8 + width + 50 + 60
        
        return CGSize(width: width, height: height)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FEED_POST_CELL, for: indexPath) as? FeedPostCell else { return FeedPostCell() }
        
        cell.post = self.posts[indexPath.item]
        
        return cell
    }
}
