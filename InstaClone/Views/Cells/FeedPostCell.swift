//
//  FeedPostCell.swift
//  InstaClone
//
//  Created by Andrii Zakharenkov on 3/8/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit

class FeedPostCell: UICollectionViewCell {
    
    var post: UserPost? {
        didSet {
            guard let postImg = post?.imageUrl else { return }
            guard let userProfileImg = post?.user.profileImgUrl else { return }
            
            self.photoImageView.fetchImage(withUrlString: postImg)
            self.userProfileImageView.fetchImage(withUrlString: userProfileImg)
            
            usernameLbl.text = post?.user.username
            setupAttributedCaption()
        }
    }
    
    let photoImageView: CustomazibleImageView = {
        let img = CustomazibleImageView()
        img.backgroundColor = .white
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        
        return img
    }()
    
    let userProfileImageView: CustomazibleImageView = {
        let img = CustomazibleImageView()
        img.backgroundColor = .white
        img.layer.cornerRadius = 40 / 2
        
        return img
    }()
    
    let usernameLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Username"
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        
        return lbl
    }()
    
    let optionsBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("•••", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        
        return btn
    }()
    
    let likeBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "like_unselected")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        return btn
    }()
    
    let commentBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "comment")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        return btn
    }()
    
    let shareBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "send2")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        return btn
    }()
    
    let saveBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "ribbon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        return btn
    }()
    
    let captionLbl: UILabel = {
        let lbl = UILabel()
        
        lbl.numberOfLines = 0
        return lbl
    }()
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(userProfileImageView)
        addSubview(usernameLbl)
        addSubview(optionsBtn)
        addSubview(photoImageView)
        
        userProfileImageView.anchor(top: topAnchor, left: leftAnchor, right: nil, bottom: nil, paddingTop: 8, paddingRight: 0, paddingLeft: 8, paddingBottom: 0, width: 40, height: 40)
        
        usernameLbl.anchor(top: topAnchor, left: userProfileImageView.rightAnchor, right: optionsBtn.leftAnchor, bottom: photoImageView.topAnchor, paddingTop: 0, paddingRight: 0, paddingLeft: 8, paddingBottom: 0, width: 0, height: 0)
        
        optionsBtn.anchor(top: topAnchor, left: nil, right: rightAnchor, bottom: photoImageView.topAnchor, paddingTop: 0, paddingRight: 8, paddingLeft: 0, paddingBottom: 0, width: 44, height: 0)
        
        photoImageView.anchor(top: userProfileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: nil, paddingTop: 8, paddingRight: 0, paddingLeft: 0, paddingBottom: 0, width: 0, height: 0)
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        setupActionsStack()
    
        addSubview(captionLbl)
        
        captionLbl.anchor(top: likeBtn.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 0, paddingRight: 8, paddingLeft: 8, paddingBottom: 0, width: 0, height: 0)
    }
    
    fileprivate func setupAttributedCaption() {
        
        guard let post = self.post else { return }
        
        let attributedText = NSMutableAttributedString(string: post.user.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: " \(post.caption)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)
        ]))
        
        
        let timeAgo = post.creationDate.timeAgo()
        
        attributedText.append(NSAttributedString(string: "\(timeAgo)", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.gray,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)
        ]))
        
        self.captionLbl.attributedText = attributedText
    }
    
    fileprivate func setupActionsStack() {
        let stack = UIStackView(arrangedSubviews: [
                likeBtn,
                commentBtn,
                shareBtn
        ])
        
        stack.distribution = .fillEqually
        
        addSubview(stack)
        
        stack.anchor(top: photoImageView.bottomAnchor, left: leftAnchor, right: nil, bottom: nil, paddingTop: 0, paddingRight: 0, paddingLeft: 4, paddingBottom: 0, width: 120, height: 50)
        
        addSubview(saveBtn)
        
        saveBtn.anchor(top: photoImageView.bottomAnchor, left: nil, right: rightAnchor, bottom: nil, paddingTop: 0, paddingRight: 4, paddingLeft: 0, paddingBottom: 0, width: 40, height: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
