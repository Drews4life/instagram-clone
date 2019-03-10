//
//  CommentsCell.swift
//  InstaClone
//
//  Created by Andrii Zakharenkov on 3/10/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit

class CommentsCell: UICollectionViewCell {
    
    var comment: Comment? {
        didSet {
            guard let comment = comment else { return }
            
            let attributedText = NSMutableAttributedString(string: comment.user.username, attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)
            ])
            
            attributedText.append(NSAttributedString(string: " \(comment.text)", attributes: [
                //NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
            ]))
            
            textView.attributedText = attributedText
            profileImageView.fetchImage(withUrlString: comment.user.profileImgUrl)
        }
    }
    
    let profileImageView: CustomazibleImageView = {
        let img = CustomazibleImageView()
        img.layer.cornerRadius = 40 / 2
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        
        return img
    }()
    
    let textView: UITextView = {
        let txtView = UITextView()
        txtView.font = UIFont.systemFont(ofSize: 14)
        txtView.isScrollEnabled = false
        txtView.isEditable = false
        
        return txtView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        addSubview(textView)
        addSubview(profileImageView)
        
        profileImageView.anchor(top: topAnchor, left: leftAnchor, right: nil, bottom: nil, paddingTop: 8, paddingRight: 0, paddingLeft: 8, paddingBottom: 0, width: 40, height: 40)
        
        textView.anchor(top: topAnchor, left: profileImageView.rightAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 5, paddingRight: 5, paddingLeft: 5, paddingBottom: 5, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
