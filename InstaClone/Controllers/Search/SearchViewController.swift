//
//  SearchViewController.swift
//  InstaClone
//
//  Created by Andrii Zakharenkov on 3/8/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    var users = [User]()
    var filteredUsers = [User]()
    
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Enter username"
        bar.barTintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
        bar.delegate = self
        
        return bar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        navigationController?.navigationBar.addSubview(searchBar)
        let navBar = navigationController?.navigationBar
        
        searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, right: navBar?.rightAnchor, bottom: navBar?.bottomAnchor, paddingTop: 8, paddingRight: 8, paddingLeft: 8, paddingBottom: 8, width: 0, height: 0)
        
        collectionView.register(SearchUserCell.self, forCellWithReuseIdentifier: SEARCHED_USER_CELL)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
        
        fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.isHidden = false
    }
    
    fileprivate func fetchUsers() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database
            .usersRef()
            .observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String : Any] else { return }
                
                dictionary.forEach({ (key, value) in
                    guard let usersDictionary = value as? [String : Any] else { return }
                    
                    if key == uid {
                        return
                    }
                    
                    let user = User(uid: key, dictionary: usersDictionary)
                    
                    self.users.append(user)
                })
                
                self.users.sort(by: { (user1, user2) -> Bool in
                    return user1.username.compare(user2.username) == .orderedAscending
                })
                
                self.filteredUsers = self.users
                self.collectionView.reloadData()
                
            }) { (error) in
                debugPrint("Cannot get users: \(error.localizedDescription)")
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            self.filteredUsers = self.users
        } else {
            self.filteredUsers = self.users.filter { (user) -> Bool in
                return user.username.lowercased().contains(searchText.lowercased())
            }
        }
        
        self.collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = self.filteredUsers[indexPath.item]
        
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        
        let userProfileVC = UserProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileVC.userId = user.uid
        
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        
        return CGSize(width: width, height: 70)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SEARCHED_USER_CELL, for: indexPath) as? SearchUserCell else { return SearchUserCell() }
        
        cell.user = self.filteredUsers[indexPath.item]
        
        return cell
    }
}
