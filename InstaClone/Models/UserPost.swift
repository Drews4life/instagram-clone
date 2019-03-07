//
//  UserPost.swift
//  InstaClone
//
//  Created by Andrii Zakharenkov on 3/7/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import Foundation

struct UserPost {
    let imageUrl: String
    
    init(dictionary: [String : Any]) {
        imageUrl = dictionary["imageUrl"] as? String ?? ""
    }
}
