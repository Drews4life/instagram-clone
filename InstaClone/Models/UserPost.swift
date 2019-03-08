//
//  UserPost.swift
//  InstaClone
//
//  Created by Andrii Zakharenkov on 3/7/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import Foundation

struct UserPost {
    
    public private(set) var imageUrl: String
    public private(set) var caption: String
    public private(set) var user: User
    
    init(user: User, dictionary: [String : Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["postMessage"] as? String ?? ""
        self.user = user
    }
}
