//
//  CommentInputview.swift
//  InstaClone
//
//  Created by Andrii Zakharenkov on 3/12/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit
import Firebase

protocol CommentInputViewDelegate {
    func didSubmit(comment: String, completion: @escaping (_ success: Bool) -> Void)
}

class CommentInputView: UIView, UITextViewDelegate {
    
    var delegate: CommentInputViewDelegate?
    
    let submitBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Send", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(onCommentSubmit), for: .touchUpInside)
        
        return btn
    }()
    
    let commentTextView: UITextView = {
        let textView = UITextView()
        textView.attributedText = NSAttributedString(string:
            "Enter your comment...", attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
        ])
        
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 14)
        
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //1
        autoresizingMask = .flexibleHeight
        commentTextView.delegate = self
        
        backgroundColor = .white
        
        setupView()
    }
    
    //2
    override var intrinsicContentSize: CGSize {
        return CGSize.zero
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if commentTextView.text == "Enter your comment..." {
            commentTextView.text = ""
            commentTextView.typingAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
            ]
        }
    }
    

    
    fileprivate func setupView() {
        addSubview(submitBtn)
        addSubview(commentTextView)
        
        
        submitBtn.anchor(top: topAnchor, left: nil, right: rightAnchor, bottom: nil, paddingTop: 0, paddingRight: 12, paddingLeft: 0, paddingBottom: 0, width: 50, height: 50)
        
        
        commentTextView.anchor(top: topAnchor, left: leftAnchor, right: submitBtn.leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, paddingTop: 8, paddingRight: 0, paddingLeft: 12, paddingBottom: 8, width: 0, height: 0)
        
        let separator = UIView()
        separator.backgroundColor = UIColor(white: 0, alpha: 0.5)
        addSubview(separator)
        
        separator.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: nil, paddingTop: 0, paddingRight: 0, paddingLeft: 0, paddingBottom: 0, width: 0, height: 0.5)
    }
    
    @objc func onCommentSubmit() {
        guard let comment = self.commentTextView.text, comment.count > 0 else { return }
        commentTextView.resignFirstResponder()
        
        delegate?.didSubmit(comment: comment, completion: { (success) in
            self.commentTextView.text = ""
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
