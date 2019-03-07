//
//  CustomizableImageViewController.swift
//  InstaClone
//
//  Created by Andrii Zakharenkov on 3/7/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit

class CustomazibleImageView: UIImageView {
    
    var lastUsedURL: String?
    
    func fetchImage(withUrlString url: String) {
        
        lastUsedURL = url
        
        guard let downloadUrl = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: downloadUrl) { (data, response, error) in
            if let err = error {
                debugPrint("could not fetch image: \(err.localizedDescription)")
                return
            }
            
            if downloadUrl.absoluteString != self.lastUsedURL {
                return
            }
            
            guard let imgData = data else { return }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: imgData)
            }
            
        }.resume()
    }
}
