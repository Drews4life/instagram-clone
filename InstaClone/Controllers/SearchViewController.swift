//
//  SearchViewController.swift
//  InstaClone
//
//  Created by Andrii Zakharenkov on 3/8/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit

class SearchViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Enter username"
        bar.barTintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
        
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
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        
        return CGSize(width: width, height: 70)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SEARCHED_USER_CELL, for: indexPath) as? SearchUserCell else { return SearchUserCell() }
        
     
        
        return cell
    }
}
