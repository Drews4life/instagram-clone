//
//  UserHeader.swift
//  InstaClone
//
//  Created by Andrii Zakharenkov on 3/2/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit
import Firebase

enum ButtonStyle {
    case blue, white
}

protocol UserHeaderDelegate {
    func onChangeGridToList()
    func onChangeListToGrid()
}

class UserHeader: UICollectionViewCell {
    
    var delegate: UserHeaderDelegate?
    
    let profileImageView: CustomazibleImageView = {
        let img = CustomazibleImageView()
        img.backgroundColor = .white
        img.layer.cornerRadius = 80 / 2
        img.clipsToBounds = true
        
        return img
    }()
    
    lazy var gridButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "grid"), for: .normal)
        btn.addTarget(self, action: #selector(changeListToGrid), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var listButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "list"), for: .normal)
        btn.tintColor = UIColor(white: 0, alpha: 0.3)
        btn.addTarget(self, action: #selector(changeGridToList), for: .touchUpInside)
        
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
    
    lazy var editProfileOrFollowButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Edit Profile", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 3
        btn.addTarget(self, action: #selector(handleEditProfileOrFollow), for: .touchUpInside)
        
        return btn
    }()
    
    var user: User? {
        didSet {
            self.usernameLbl.text = user?.username ?? "You"
            
            guard let imgUrl = user?.profileImgUrl else { return }
            self.profileImageView.fetchImage(withUrlString: imgUrl)
            
            setupEditFollowBtn()
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
        
        addSubview(editProfileOrFollowButton)
        editProfileOrFollowButton.anchor(top: postLabel.bottomAnchor, left: postLabel.leftAnchor, right: followingLabel.rightAnchor, bottom: nil, paddingTop: 5, paddingRight: 0, paddingLeft: 0, paddingBottom: 0, width: 0, height: 35)
    }
    
    fileprivate func setupEditFollowBtn() {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        guard let userUid = user?.uid else { return }
        
        if currentUserUid == userUid {
            
        } else {
            
            Database
                .followingRef()
                .child(currentUserUid)
                .child(userUid)
                .observeSingleEvent(of: .value) { (userSnapshot) in
                    
                    if let isFollowing = userSnapshot.value as? Int, isFollowing == 1 {
                        self.toggleButtonStyle(style: .white)
                    } else {
                        self.toggleButtonStyle(style: .blue)
                    }
            }
        }
    }
    
    @objc func changeGridToList() {
        listButton.tintColor = #colorLiteral(red: 0.06666666667, green: 0.6039215686, blue: 0.9294117647, alpha: 1)
        gridButton.tintColor = UIColor(white: 0, alpha: 0.3)
        
        delegate?.onChangeGridToList()
    }
    
    @objc func changeListToGrid() {
        listButton.tintColor = UIColor(white: 0, alpha: 0.3)
        gridButton.tintColor = #colorLiteral(red: 0.06666666667, green: 0.6039215686, blue: 0.9294117647, alpha: 1)
        
        delegate?.onChangeListToGrid()
    }
    
    @objc func handleEditProfileOrFollow() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        
        if uid == userId {
            return
        }
        
        if editProfileOrFollowButton.titleLabel?.text == "Unfollow" {
            
            Database
                .followingRef()
                .child(uid)
                .child(userId)
                .removeValue { (error, ref) in
                    if let err = error {
                        debugPrint("Could not unfollow a person: \(err.localizedDescription)")
                        return
                    }
                    
                    self.toggleButtonStyle(style: .blue)
            }
            
        } else {
            let values = [userId: 1]
            
            Database
                .followingRef()
                .child(uid)
                .updateChildValues(values) { (error, ref) in
                    if let err = error {
                        debugPrint("Could not update following for user: \(err.localizedDescription)")
                        return
                    }
                    self.toggleButtonStyle(style: .white)
            }
        }
    }
    
    func toggleButtonStyle(style: ButtonStyle) {
        switch style {
            case .blue:
                self.editProfileOrFollowButton.setTitle("Follow", for: .normal)
                self.editProfileOrFollowButton.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.6039215686, blue: 0.9294117647, alpha: 1)
                self.editProfileOrFollowButton.setTitleColor(.white, for: .normal)
                self.editProfileOrFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
            default:
                self.editProfileOrFollowButton.setTitle("Unfollow", for: .normal)
                self.editProfileOrFollowButton.backgroundColor = .white
                self.editProfileOrFollowButton.setTitleColor(.black, for: .normal)
            }
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
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
