//
//  PreviewPhotoView.swift
//  InstaClone
//
//  Created by Andrii Zakharenkov on 3/10/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit
import Photos

class PreviewPhotoView: UIView {
    
    let previewImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        
        return img
    }()
    
    let saveBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "save_shadow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(saveBtnClick), for: .touchUpInside)
        
        return btn
    }()
    
    let cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .system)
        cancelBtn.setImage(UIImage(named: "cancel_shadow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelBtnClick), for: .touchUpInside)
        
        return cancelBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(previewImageView)
        addSubview(cancelBtn)
        addSubview(saveBtn)
        
        previewImageView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 0, paddingRight: 0, paddingLeft: 0, paddingBottom: 0, width: 0, height: 0)
        
        cancelBtn.anchor(top: topAnchor, left: leftAnchor, right: nil, bottom: nil, paddingTop: 12, paddingRight: 0, paddingLeft: 12, paddingBottom: 0, width: 50, height: 50)
        
        saveBtn.anchor(top: nil, left: leftAnchor, right: nil, bottom: bottomAnchor, paddingTop: 0, paddingRight: 0, paddingLeft: 12, paddingBottom: 12, width: 50, height: 50)
    }
    
    @objc func saveBtnClick() {
        guard let image = self.previewImageView.image else { return }
        
        let library = PHPhotoLibrary.shared()
        
        library.performChanges({
            
            PHAssetChangeRequest.creationRequestForAsset(from: image)
            
        }) { (success, error) in
            if let err = error {
                debugPrint("failed to save image: \(err.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async {
                self.showSavedLabel()
            }
        }
    }
    
    @objc func cancelBtnClick() {
        self.removeFromSuperview()
    }
    
    func showSavedLabel() {
        let savedLbl = UILabel()
        savedLbl.text = "Saved Successfully"
        savedLbl.font = UIFont.boldSystemFont(ofSize: 18)
        savedLbl.textColor = .white
        savedLbl.backgroundColor = UIColor(white: 0, alpha: 0.3)
        savedLbl.textAlignment = .center
        savedLbl.numberOfLines = 0
        
        savedLbl.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
        savedLbl.center = self.center
        
        addSubview(savedLbl)
        savedLbl.layer.transform = CATransform3DMakeScale(0, 0, 0)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            savedLbl.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }) { (_) in
            UIView.animate(withDuration: 0.5, delay: 0.75, options: .curveEaseOut, animations: {
                savedLbl.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                savedLbl.alpha = 0
            }, completion: { (_) in
                savedLbl.removeFromSuperview()
            })
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
