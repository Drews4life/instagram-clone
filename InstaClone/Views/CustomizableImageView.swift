//
//  CustomizableImageViewController.swift
//  InstaClone
//
//  Created by Andrii Zakharenkov on 3/7/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()

class CustomazibleImageView: UIImageView {
    
    var lastUsedURL: String?
    
    func fetchImage(withUrlString url: String) {
        
        lastUsedURL = url
        
        self.image = nil
        
        if let cachedImg = imageCache[url] {
            self.image = cachedImg
            return
        }
        
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
            guard let image = UIImage(data: imgData) else { return }
            
            imageCache[downloadUrl.absoluteString] = image
            
            DispatchQueue.main.async {
                self.image = image
            }
            
        }.resume()
    }
}
