//
//  CommentsViewController.swift
//  InstaClone
//
//  Created by Andrii Zakharenkov on 3/10/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit
import Firebase

class CommentsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var post: UserPost?
    var comments = [Comment]()
    
    let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your comment..."
        
        return textField
    }()
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        let sendBtn = UIButton(type: .system)
        sendBtn.setTitle("Send", for: .normal)
        sendBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        sendBtn.addTarget(self, action: #selector(onCommentSubmit), for: .touchUpInside)
        
        containerView.addSubview(sendBtn)
        sendBtn.anchor(top: containerView.topAnchor, left: nil, right: containerView.rightAnchor, bottom: containerView.bottomAnchor, paddingTop: 0, paddingRight: 12, paddingLeft: 0, paddingBottom: 0, width: 50, height: 0)
        

        containerView.addSubview(commentTextField)
        commentTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, right: sendBtn.leftAnchor, bottom: containerView.bottomAnchor, paddingTop: 0, paddingRight: 0, paddingLeft: 12, paddingBottom: 0, width: 0, height: 0)
    
        
        let separator = UIView()
        separator.backgroundColor = UIColor(white: 0, alpha: 0.5)
        containerView.addSubview(separator)
        
        separator.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, bottom: nil, paddingTop: 0, paddingRight: 0, paddingLeft: 0, paddingBottom: 0, width: 0, height: 0.5)
        
        return containerView
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
    
    @objc func onCommentSubmit() {
        commentTextField.resignFirstResponder()
        
        guard let comment = commentTextField.text, comment.count > 0 else { return }
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
                    return
                }
                
                self.commentTextField.text = ""
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
