//
//  Comment.swift
//  InstaClone
//
//  Created by Andrii Zakharenkov on 3/10/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import Foundation

struct Comment {
    public private(set) var text: String
    public private(set) var uid: String
    public private(set) var user: User
    
    init(dictionary: [String : Any], user: User) {
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.user = user
    }
}
