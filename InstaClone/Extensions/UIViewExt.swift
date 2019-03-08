//
//  UIViewExt.swift
//  InstaClone
//
//  Created by Andrii Zakharenkov on 3/2/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit
import Firebase

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, right: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, paddingTop: CGFloat, paddingRight: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}


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
}
