//
//  ViewController.swift
//  InstaClone
//
//  Created by Andrii Zakharenkov on 3/2/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        button.addTarget(self, action: #selector(handleOnAvatarClick), for: .touchUpInside)
        
        return button
    }()
    
    let emailTxtField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "email"
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(handleInputChange), for: .editingChanged)
        
        return textField
    }()
    
    let usernameTxtField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "username"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(handleInputChange), for: .editingChanged)
        
        return textField
    }()
    
    let passwordTxtField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "password"
        textField.isSecureTextEntry = true
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(handleInputChange), for: .editingChanged)
        
        return textField
    }()
    
    let signUpBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.5843137255, green: 0.8, blue: 0.9568627451, alpha: 1)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.isEnabled = false
        
        return button
    }()
    
    let backToLogin: UIButton = {
        let btn = UIButton(type: .system)
        
        let attributedString = NSMutableAttributedString(string: "Already have an account?  ", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ])
        
        attributedString.append(NSAttributedString(string: "Back to Log in!", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.06666666667, green: 0.6039215686, blue: 0.9294117647, alpha: 1)
            ]))
        
        btn.setAttributedTitle(attributedString, for: .normal)
        
        btn.addTarget(self, action: #selector(navigateToCreateAccount), for: .touchUpInside)
        
        return btn
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.color = .black
        activity.stopAnimating()
        
        return activity
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = .white
        view.addSubview(plusButton)
        view.addSubview(backToLogin)
        
        backToLogin.anchor(top: nil, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, paddingTop: 0, paddingRight: 0, paddingLeft: 0, paddingBottom: 0, width: 0, height: 50)
        
        plusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plusButton.anchor(top: view.topAnchor, left: nil, right: nil, bottom: nil, paddingTop: 40, paddingRight: 0, paddingLeft: 0, paddingBottom: 0, width: 140, height: 140)
        
        setupInputFields()
        
       
    }
    
    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [
            emailTxtField,
            usernameTxtField,
            passwordTxtField,
            signUpBtn
        ])
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(top: plusButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, paddingTop: 20, paddingRight: 40, paddingLeft: 40, paddingBottom: 0, width: 0, height: 200)
        
        view.addSubview(activityIndicator)
        
        activityIndicator.anchor(top: stackView.bottomAnchor, left: nil, right: nil, bottom: nil, paddingTop: 25, paddingRight: 0, paddingLeft: 0, paddingBottom: 0, width: 25, height: 25)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc func handleInputChange() {
        let isFormValid =
            emailTxtField.text?.count ?? 0 > 0 &&
            usernameTxtField.text?.count ?? 0 > 0 &&
            passwordTxtField.text?.count ?? 0 > 0
        
        
        if isFormValid {
            signUpBtn.isEnabled = true
            signUpBtn.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.6039215686, blue: 0.9294117647, alpha: 1)
        } else {
            signUpBtn.isEnabled = false
            signUpBtn.backgroundColor = #colorLiteral(red: 0.5843137255, green: 0.8, blue: 0.9568627451, alpha: 1)
        }
    }

    @objc func handleOnAvatarClick() {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        imagePickerVC.allowsEditing = true
        
        present(imagePickerVC, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage {
            plusButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if  let originalImage = info[.originalImage] as? UIImage {
            plusButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        plusButton.layer.cornerRadius = plusButton.frame.width / 2
        plusButton.layer.borderColor = #colorLiteral(red: 0.06666666667, green: 0.6039215686, blue: 0.9294117647, alpha: 1)
        plusButton.layer.borderWidth = 1.5
        plusButton.layer.masksToBounds = true
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func navigateToCreateAccount() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSignUp() {
        guard let email = emailTxtField.text, email.count > 0 else { return }
        guard let username = usernameTxtField.text, username.count > 0 else { return }
        guard let password = passwordTxtField.text, password.count > 0 else { return }
        
        activityIndicator.startAnimating()
        
        Auth.auth().createUser(withEmail: email, password: password) { (authDataRes, error) in
            if let err = error {
                debugPrint("failed to create user: \(err.localizedDescription)")
                self.activityIndicator.stopAnimating()
                return
            }
            guard let user = authDataRes?.user else { return }
            guard let image = self.plusButton.imageView?.image else { return }
            guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
            
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = username
            changeRequest.commitChanges(completion: nil)
            
            self.uploadImageToFIR(uploadData: uploadData, completion: { (success, downloadUrl) in
                if success {
                    
                    guard let url = downloadUrl?.absoluteString else { return }
                    
                    let userValues: [String : Any] = [
                        "username": username,
                        "profileImageUrl": url
                    ]
                    
                    let newUser = [user.uid: userValues]
                    
                    self.setUserInFIR(newUser: newUser)
                } else {
                    self.activityIndicator.stopAnimating()
                    debugPrint("failed to upload image or to get download url")
                }
            })
        }
    }
    
    func uploadImageToFIR(uploadData: Data, completion: @escaping (_ success: Bool, _ url: URL?) -> Void) {
        let filename = NSUUID().uuidString
        
        let storageRef = Storage
            .storage()
            .reference()
            .child("profile_images")
            .child(filename)
        
        storageRef.putData(uploadData, metadata: nil, completion: { (meta, error) in
            if let err = error {
                debugPrint("Could not save image to storage: \(err.localizedDescription)")
                completion(false, nil)
                return
            }
            
            storageRef.downloadURL(completion: { (downloadUrl, error) in
                if let err = error {
                    debugPrint("Could not retrieve download url: \(err.localizedDescription)")
                    completion(false, nil)
                    return
                }
                guard let url = downloadUrl else { return }
                completion(true, url)
            })
            
        })
    }
    
    func setUserInFIR(newUser: [String : [String : Any]]) {
        Database
            .database()
            .reference()
            .child("users/")
            .updateChildValues(newUser, withCompletionBlock: { (error, ref) in
                
                self.activityIndicator.stopAnimating()
                
                if let err = error {
                    debugPrint("Failed name assignment: \(err.localizedDescription)")
                    return
                }
                
                guard let mainTabVC = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                mainTabVC.setupTabNavigation()
               
                self.dismiss(animated: true, completion: nil)
        })
    }
}

