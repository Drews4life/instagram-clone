//
//  User.swift
//  InstaClone
//
//  Created by Andrii Zakharenkov on 3/3/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import Foundation

struct User {
    public private(set) var username: String
    public private(set) var profileImgUrl: String
    public private(set) var uid: String
    
    init(uid: String, dictionary: [String : Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImgUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = uid
    }
}
