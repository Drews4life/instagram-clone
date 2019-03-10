//
//  HomeViewController.swift
//  InstaClone
//
//  Created by Andrii Zakharenkov on 3/8/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, FeedPostCellDelegate {
    
    private let postsRef = Database.database().reference().child("posts")
    private let usersRef = Database.database().reference().child("users")
    
    private var posts = [UserPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleRefresh), name: NEW_PHOTO_UPLOADED_NOTIFICATION, object: nil)
    
        collectionView.backgroundColor = .white
        collectionView.register(FeedPostCell.self, forCellWithReuseIdentifier: FEED_POST_CELL)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        setupNavBar()
        
        if let uid = Auth.auth().currentUser?.uid {
            fetchFeedPosts(withId: uid)
            fetchUserIds()
        }
    }
    
    func onLikeTap(forCell cell: FeedPostCell) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        var post = self.posts[indexPath.item]
        guard let postId = post.id else { return }
        
        let values = [uid: post.isLiked ? 0 : 1]
        
        Database
            .likesRef()
            .child(postId)
            .updateChildValues(values) { (error, ref) in
                if let err = error {
                    debugPrint("Could not like the post with error: \(err.localizedDescription)")
                    return
                }
                
                post.isLiked = !post.isLiked
                self.posts[indexPath.item] = post
                self.collectionView.reloadItems(at: [indexPath])
        }
    }
    
    func onCommentTap(post: UserPost) {
        let commentsVC = CommentsViewController(collectionViewLayout: UICollectionViewFlowLayout())
        commentsVC.post = post
        navigationController?.pushViewController(commentsVC, animated: true)
    }
    
    fileprivate func setupNavBar() {
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo2")?.withRenderingMode(.alwaysOriginal))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "camera3")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showCamera))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "send2")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(onMessageViewClick))
    }
    
    @objc func handleRefresh() {
        if let uid = Auth.auth().currentUser?.uid {
            posts.removeAll()
            
            fetchFeedPosts(withId: uid)
            fetchUserIds()
        }
        
    }
    
    @objc func showCamera() {
        let cameraVC = CameraViewController()
        
        self.present(cameraVC, animated: true, completion: nil)
    }
    
    @objc func onMessageViewClick() {
        
    }
    
    fileprivate func fetchUserIds() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database
            .followingRef()
            .child(uid)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                guard let idsDictionary = snapshot.value as? [String : Any] else { return }
                
                idsDictionary.forEach({ (key, _) in
                    self.fetchFeedPosts(withId: key)
                })
                
            }) { (error) in
                debugPrint("Unable to fetch following users ids: \(error.localizedDescription)")
        }
    }
    
    fileprivate func fetchFeedPosts(withId id: String) {
        //guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.fetchUser(withUid: id) { (success, user) in
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
                
                self.collectionView.refreshControl?.endRefreshing()
                
                guard let snapDictionary = snapshot.value as? [String : Any] else { return }
                
                snapDictionary.forEach({ (key, value) in
                    guard let dictionary = value as? [String : Any] else { return }
                    
                    var post = UserPost(user: user, dictionary: dictionary)
                    post.id = key
                    
                    guard let uid = Auth.auth().currentUser?.uid else { return }
                    Database
                        .likesRef()
                        .child(key)
                        .child(uid)
                        .observeSingleEvent(of: .value, with: { (snapshot) in
                           
                            if let value = snapshot.value as? Int, value == 1 {
                                post.isLiked = true
                            } else {
                                post.isLiked = false
                            }
                            
                            self.posts.append(post)
                            self.posts.sort(by: { (post1, post2) -> Bool in
                                return post1.creationDate.compare(post2.creationDate) == .orderedDescending
                            })
                            self.collectionView.reloadData()
                            
                        }, withCancel: { (error) in
                            debugPrint("Could not fetch likes for post: \(error.localizedDescription)")
                        })
                    
                })
                
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
        cell.delegate = self
        
        return cell
    }
}
