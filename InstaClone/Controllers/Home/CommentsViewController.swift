//
//  CommentsViewController.swift
//  InstaClone
//
//  Created by Andrii Zakharenkov on 3/10/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit
import Firebase

class CommentsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CommentInputViewDelegate {
    
    var post: UserPost?
    var comments = [Comment]()
    
   
    
    lazy var containerView: CommentInputView = {
        let commentInputView = CommentInputView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        commentInputView.delegate = self
        
        return commentInputView
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.title = "Comments"
    
        collectionView.register(CommentsCell.self, forCellWithReuseIdentifier: COMMENT_CELL)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
//        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.backgroundColor = .white
        
        
        fetchComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    fileprivate func fetchComments() {
        guard let postId = self.post?.id else { return }
        
        Database
            .commentsRef()
            .child(postId)
            .observe(.childAdded, with: { (snapshot) in
                guard let commentDictionary = snapshot.value as? [String : Any] else { return }
                guard let uid = commentDictionary["uid"] as? String else { return }
                
                Database.fetchUser(withUid: uid, completion: { (success, user) in
                    guard let user = user else { return }
                  
                    let comment = Comment(dictionary: commentDictionary, user: user)
                    self.comments.append(comment)
                    self.collectionView.reloadData()
                })
                
            }) { (error) in
                debugPrint("Unable to fetch comments: \(error.localizedDescription)")
        }
    }
    
    func didSubmit(comment: String, completion: @escaping (Bool) -> Void) {
        guard let postId = post?.id else { return }
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let values: [String : Any] = [
            "text": comment,
            "creationDate": Date().timeIntervalSince1970,
            "uid": userId
        ]
        
        Database
            .commentsRef()
            .child(postId)
            .childByAutoId()
            .updateChildValues(values) { (error, ref) in
                if let err = error {
                    debugPrint("Received error while trying to get comments: \(err.localizedDescription)")
                    completion(false)
                    return
                }
                
                completion(true)
               
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        let frame = CGRect(x: 0, y: 0, width: width, height: 50)
        let dummyCell = CommentsCell(frame: frame)
        dummyCell.comment = comments[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        let height = max(40 + 8 + 8, estimatedSize.height)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: COMMENT_CELL, for: indexPath) as? CommentsCell else { return CommentsCell() }

        cell.comment = self.comments[indexPath.item]
        
        return cell
    }
}
