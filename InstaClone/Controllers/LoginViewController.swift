//
//  LoginViewController.swift
//  InstaClone
//
//  Created by Andrii Zakharenkov on 3/3/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let signUpBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Don't have an account? Sign up!", for: .normal)
        btn.addTarget(self, action: #selector(navigateToCreateAccount), for: .touchUpInside)
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        view.addSubview(signUpBtn)
        
        signUpBtn.anchor(top: nil, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, paddingTop: 0, paddingRight: 0, paddingLeft: 0, paddingBottom: 0, width: 0, height: 50)
    }
    
    @objc func navigateToCreateAccount() {
        let createAccountVC = CreateAccountViewController()
        
        navigationController?.pushViewController(createAccountVC, animated: true)
    }
}
