//
//  UserHeader.swift
//  InstaClone
//
//  Created by Andrii Zakharenkov on 3/2/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit

class UserHeader: UICollectionViewCell {
    
    let profileImageView: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .white
        img.layer.cornerRadius = 80 / 2
        img.clipsToBounds = true
        
        return img
    }()
    
    let gridButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "grid"), for: .normal)
        //btn.tintColor = UIColor(white: 0, alpha: 0.1)
        
        return btn
    }()
    
    let listButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "list"), for: .normal)
        btn.tintColor = UIColor(white: 0, alpha: 0.3)
        
        return btn
    }()
    
    let bookmarkButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "ribbon"), for: .normal)
        btn.tintColor = UIColor(white: 0, alpha: 0.3)
        
        return btn
    }()
    
    let usernameLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "username"
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        
        return lbl
    }()
    
    let postLabel: UILabel = {
        let lbl = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "posts", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
        ]))
        
        lbl.attributedText = attributedText
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        
        return lbl
    }()
    
    let followersLabel: UILabel = {
        let lbl = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "followers", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
        ]))
        
        lbl.attributedText = attributedText
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        
        return lbl
    }()
    
    let followingLabel: UILabel = {
        let lbl = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "following", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
            ]))
        
        lbl.attributedText = attributedText
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        
        return lbl
    }()
    
    let editProfileButtom: UIButton = {
        let btn = UIButton()
        btn.setTitle("Edit Profile", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 3
        
        return btn
    }()
    
    var user: User? {
        didSet {
            self.usernameLbl.text = user?.username ?? "You"
            self.setupProfileImg()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, right: nil, bottom: nil, paddingTop: 12, paddingRight: 0, paddingLeft: 12, paddingBottom: 0, width: 80, height: 80)
        
    
        setupBottomToolStack()
        
        addSubview(usernameLbl)
        usernameLbl.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: gridButton.topAnchor, paddingTop: 4, paddingRight: 12, paddingLeft: 20, paddingBottom: 0, width: 0, height: 0)
        
        setupTopUserStats()
        
        addSubview(editProfileButtom)
        editProfileButtom.anchor(top: postLabel.bottomAnchor, left: postLabel.leftAnchor, right: followingLabel.rightAnchor, bottom: nil, paddingTop: 5, paddingRight: 0, paddingLeft: 0, paddingBottom: 0, width: 0, height: 35)
    }
    
    fileprivate func setupBottomToolStack() {
        
        let topDividerView = UIView()
        topDividerView.backgroundColor = UIColor.lightGray
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = UIColor.lightGray
        
        let stack = UIStackView(arrangedSubviews: [
            gridButton,
            listButton,
            bookmarkButton
        ])

        stack.distribution = .fillEqually
        
        addSubview(stack)
        addSubview(topDividerView)
        addSubview(bottomDividerView)

        stack.anchor(top: nil, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 0, paddingRight: 0, paddingLeft: 0, paddingBottom: 0, width: 0, height: 50)
        
        topDividerView.anchor(top: stack.topAnchor, left: leftAnchor, right: rightAnchor, bottom: nil, paddingTop: 0, paddingRight: 0, paddingLeft: 0, paddingBottom: 0, width: 0, height: 0.7)
        
        bottomDividerView.anchor(top: nil, left: leftAnchor, right: rightAnchor, bottom: stack.bottomAnchor, paddingTop: 0, paddingRight: 0, paddingLeft: 0, paddingBottom: 0, width: 0, height: 0.7)
    }
    
    fileprivate func setupTopUserStats() {
        let stack = UIStackView(arrangedSubviews: [
            postLabel,
            followersLabel,
            followingLabel
        ])
        
        stack.distribution = .fillEqually
        addSubview(stack)
        
        stack.anchor(top: topAnchor, left: profileImageView.rightAnchor, right: rightAnchor, bottom: nil, paddingTop: 10, paddingRight: 12, paddingLeft: 12, paddingBottom: 0, width: 0, height: 50)
    }
    
    fileprivate func setupProfileImg() {
        guard let profileImgUrl = user?.profileImgUrl else { return }
        guard let url = URL(string: profileImgUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let err = error {
                debugPrint("Cannot get image: \(err.localizedDescription)")
                return;
            }
            
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                self.profileImageView.image = UIImage(data: data)
            }
            
        }.resume()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
