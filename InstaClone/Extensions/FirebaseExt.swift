//
//  FirebaseExt.swift
//  InstaClone
//
//  Created by Andrii Zakharenkov on 3/9/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import Foundation
import Firebase


extension Database {
    static func fetchUser(withUid uid: String, completion: @escaping (_ success: Bool, _ user: User?) -> Void) {
        self.usersRef()
            .child(uid)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let userDictionary = snapshot.value as? [String : Any] else { return }
                
                let user = User(uid: uid, dictionary: userDictionary)
                
                completion(true, user)
                
            }) { (error) in
                completion(false, nil)
                debugPrint("Could not get user profile from HomeVC: \(error.localizedDescription)")
        }
    }
    
    static func postsRef() -> DatabaseReference {
        return self.database().reference().child("posts")
    }
    
    static func usersRef() -> DatabaseReference {
        return self.database().reference().child("users")
    }
    
    static func followingRef() -> DatabaseReference {
        return self.database().reference().child("following")
    }
}

