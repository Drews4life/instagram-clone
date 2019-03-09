//
//  SharePhotoViewController.swift
//  InstaClone
//
//  Created by Andrii Zakharenkov on 3/6/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoViewController: UIViewController, UITextViewDelegate {
    
    var selectedImage: UIImage? {
        didSet {
            photoThumbnail.image = selectedImage
        }
    }
    
    var photoThumbnail: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        
        return img
    }()
    
    private var userInput: UITextView = {
        let txt = UITextView()
        txt.font = UIFont.systemFont(ofSize: 16)
        
        let attributedText = NSAttributedString(string: "Your caption goes here!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        txt.attributedText = attributedText
        
        return txt
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.color = .black
        activity.stopAnimating()
        
        return activity
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(onShareClick))
        
        userInput.delegate = self
        
        setupView()
    }
    
    fileprivate func setupView() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        view.addSubview(containerView)
        view.addSubview(activityIndicator)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, paddingTop: 0, paddingRight: 0, paddingLeft: 0, paddingBottom: 0, width: 0, height: 100)
        
        containerView.addSubview(photoThumbnail)
        photoThumbnail.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, right: nil, bottom: containerView.bottomAnchor, paddingTop: 8, paddingRight: 0, paddingLeft: 8, paddingBottom: 8, width: 84, height: 0)
        
        containerView.addSubview(userInput)
        userInput.anchor(top: containerView.topAnchor, left: photoThumbnail.rightAnchor, right: containerView.rightAnchor, bottom: containerView.bottomAnchor, paddingTop: 0, paddingRight: 0, paddingLeft: 4, paddingBottom: 0, width: 0, height: 0)
        
        activityIndicator.anchor(top: containerView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, paddingTop: 12, paddingRight: 0, paddingLeft: 0, paddingBottom: 0, width: 30, height: 30)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        userInput.text = ""
        userInput.typingAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
        ]
    }
    
    @objc func onShareClick() {
        guard let message = userInput.text, message.count > 0 else { return }
        guard let image = selectedImage else { return }
        
        guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        activityIndicator.startAnimating()
        
        let filename = NSUUID().uuidString
        let storageRef = Storage
            .storage()
            .reference()
            .child("posts")
            .child(filename)
        
        
        storageRef
            .putData(uploadData, metadata: nil) { (metadata, error) in
                if let err = error {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    self.activityIndicator.stopAnimating()
                    debugPrint("Could not upload image: \(err.localizedDescription)")
                    return
                }
                
                storageRef.downloadURL(completion: { (url, error) in
                    if let err = error {
                        self.navigationItem.rightBarButtonItem?.isEnabled = true
                        self.activityIndicator.stopAnimating()
                        debugPrint("Could not get url for images: \(err.localizedDescription)")
                        return
                    }
                
                    guard let url = url else { return }
                    self.saveToDB(urlForImage: url, forPost: message, sizeForImage: image.size)
                })
        }
    }
    
    fileprivate func saveToDB(urlForImage url: URL,forPost message: String, sizeForImage size: CGSize) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
 
        let values: [String : Any] = [
            "imageUrl": "\(url)",
            "postMessage": message,
            "imageWidth": size.width,
            "imageHeight": size.height,
            "creationDate": Date().timeIntervalSince1970
        ]
        
        Database
            .postsRef()
            .child(uid)
            .childByAutoId()
            .updateChildValues(values) { (error, ref) in
                
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.activityIndicator.stopAnimating()
                
                if let err = error {
                    debugPrint("Could not update posts in db \(err.localizedDescription)")
                    return
                }

                self.dismiss(animated: true, completion: nil)
                
                NotificationCenter.default.post(name: NEW_PHOTO_UPLOADED_NOTIFICATION, object: nil)
        }
    }
}
