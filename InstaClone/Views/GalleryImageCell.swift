//
//  GalleryImageCell.swift
//  InstaClone
//
//  Created by Andrii Zakharenkov on 3/6/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit

class GalleryImageCell: UICollectionViewCell {
    
    let galleryPhoto: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .lightGray
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(galleryPhoto)
        galleryPhoto.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 0, paddingRight: 0, paddingLeft: 0, paddingBottom: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
