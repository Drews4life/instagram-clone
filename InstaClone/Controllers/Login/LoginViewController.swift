//
//  LoginViewController.swift
//  InstaClone
//
//  Created by Andrii Zakharenkov on 3/3/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    let signUpBtn: UIButton = {
        let btn = UIButton(type: .system)
        
        let attributedString = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ])
        
        attributedString.append(NSAttributedString(string: "Sign Up!", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.06666666667, green: 0.6039215686, blue: 0.9294117647, alpha: 1)
        ]))
        
        btn.setAttributedTitle(attributedString, for: .normal)
        btn.addTarget(self, action: #selector(navigateToCreateAccount), for: .touchUpInside)
        
        return btn
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
    
    let passwordTxtField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "password"
        textField.isSecureTextEntry = true
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(handleInputChange), for: .editingChanged)
        
        return textField
    }()
    
    let loginBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.5843137255, green: 0.8, blue: 0.9568627451, alpha: 1)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.isEnabled = false
        
        return button
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.color = .black
        activity.stopAnimating()
        
        return activity
    }()
    
    let logoContainer: UIView = {
        let view = UIView()
        let logo = UIImageView(image: UIImage(named: "Instagram_logo_white")?.withRenderingMode(.alwaysOriginal))
        logo.contentMode = .scaleAspectFill
        
        view.addSubview(logo)
        
        logo.anchor(top: nil, left: nil, right: nil, bottom: nil, paddingTop: 0, paddingRight: 0, paddingLeft: 0, paddingBottom: 0, width: 200, height: 50)
        
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.backgroundColor = #colorLiteral(red: 0, green: 0.4705882353, blue: 0.6862745098, alpha: 1)

        return view
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        view.addSubview(signUpBtn)
        view.addSubview(logoContainer)
        
        logoContainer.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, paddingTop: 0, paddingRight: 0, paddingLeft: 0, paddingBottom: 0, width: 0, height: 150)
        signUpBtn.anchor(top: nil, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, paddingTop: 0, paddingRight: 0, paddingLeft: 0, paddingBottom: 0, width: 0, height: 50)
        
        setupStackView()
    }
    
    fileprivate func setupStackView() {
        let stack = UIStackView(arrangedSubviews: [
            emailTxtField,
            passwordTxtField,
            loginBtn
        ])
        
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 10
        
        view.addSubview(stack)
        view.addSubview(activityIndicator)
        
        stack.anchor(top: logoContainer.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, paddingTop: 40, paddingRight: 40, paddingLeft: 40, paddingBottom: 0, width: 0, height: 150)
        
        activityIndicator.anchor(top: stack.bottomAnchor, left: nil, right: nil, bottom: nil, paddingTop: 25, paddingRight: 0, paddingLeft: 0, paddingBottom: 0, width: 25, height: 25)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc func navigateToCreateAccount() {
        let createAccountVC = CreateAccountViewController()
        
        navigationController?.pushViewController(createAccountVC, animated: true)
    }
    
    @objc func handleInputChange() {
        let isFormValid =
            emailTxtField.text?.count ?? 0 > 0 &&
            passwordTxtField.text?.count ?? 0 > 0
        
        if isFormValid {
            loginBtn.isEnabled = true
            loginBtn.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.6039215686, blue: 0.9294117647, alpha: 1)
        } else {
            loginBtn.isEnabled = false
            loginBtn.backgroundColor = #colorLiteral(red: 0.5843137255, green: 0.8, blue: 0.9568627451, alpha: 1)
        }
    }
    
    @objc func handleLogin() {
        guard let email = emailTxtField.text, email.count > 0 else { return }
        guard let password = passwordTxtField.text, password.count > 0 else { return }
        
        activityIndicator.startAnimating()
        
        Auth.auth().signIn(withEmail: email, password: password) { (authDataRes, error) in
            
            self.activityIndicator.stopAnimating()
            
            if let err = error {
                debugPrint("Unable to login: \(err.localizedDescription)")
                return
            }
            
            guard let mainTabBatVC = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
            mainTabBatVC.setupTabNavigation()
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}
