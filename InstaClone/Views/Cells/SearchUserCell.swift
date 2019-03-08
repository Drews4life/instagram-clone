//
//  SearchUserCell.swift
//  InstaClone
//
//  Created by Andrii Zakharenkov on 3/8/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit

class SearchUserCell: UICollectionViewCell {
    
    let profileImageView: CustomazibleImageView = {
        let img = CustomazibleImageView()
        img.backgroundColor = .red
        img.layer.cornerRadius = 50 / 2
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        
        return img
    }()
    
    let usernameLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Username"
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        addSubview(usernameLbl)
        
        profileImageView.anchor(top: nil, left: leftAnchor, right: nil, bottom: nil, paddingTop: 0, paddingRight: 0, paddingLeft: 8, paddingBottom: 0, width: 50, height: 50)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        usernameLbl.anchor(top: topAnchor, left: profileImageView.rightAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 0, paddingRight: 0, paddingLeft: 8, paddingBottom: 0, width: 0, height: 0)
        
        let separator = UIView()
        separator.backgroundColor = UIColor(white: 0, alpha: 0.5)
        addSubview(separator)
        separator.anchor(top: nil, left: usernameLbl.leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 0, paddingRight: 0, paddingLeft: 0, paddingBottom: 0, width: 0, height: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
