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
    
    init(username: String, profileImg: String) {
        self.username = username
        self.profileImgUrl = profileImg
    }
}
