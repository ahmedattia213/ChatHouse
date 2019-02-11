//
//  ChatLogController.swift
//  ChatHouse
//
//  Created by Ahmed Amr on 2/10/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ChatLogController: UICollectionViewController {

    let chatCellId = "chatCellId"

    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("send", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(handleSendButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var chatTextView: UITextView = {
        let textview = UITextView()
        textview.text = "Enter your message.."
        textview.textColor = .lightGray
        textview.font = UIFont.systemFont(ofSize: 12)
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.delegate = self
        return textview
    }()
    let separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexRGB: 0xDCDCDC)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        collectionView.backgroundColor = .white
        navigationItem.title = "ChatLog"
        setupInputComponentsConstraints()

    }

    func setupInputComponentsConstraints() {
        view.addSubview(containerView)
        containerView.addSubview(sendButton)
        containerView.addSubview(chatTextView)
        containerView.addSubview(separatorLineView)
        //containerView : x,y,width,height
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //sendButton : x,y,width,height
        sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        sendButton.topAnchor.constraint(equalTo: separatorLineView.topAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        //chatTextView : x,y,width,height
        chatTextView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8).isActive = true
        chatTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8).isActive = true
        chatTextView.topAnchor.constraint(equalTo: separatorLineView.topAnchor).isActive = true
        chatTextView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        //separatorLineView: x,y,width,height
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }

    @objc func handleSendButton() {
        let currentUserUid = Auth.auth().currentUser?.uid
        FirebaseHelper.fetchCurrentUserWithUid(uid: currentUserUid!) { (user) in
            let ref = Database.database().reference().child("Messages").childByAutoId()
            let values = ["message": self.chatTextView.text!, "sender": user.name]
            ref.updateChildValues(values as [AnyHashable: Any])
            self.chatTextView.text = ""
        }

    }
}

extension ChatLogController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if   textView.text == "Enter your message.." && textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
            textView.font = UIFont.systemFont(ofSize: 14)

        }
        textView.becomeFirstResponder()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.font = UIFont.systemFont(ofSize: 12)
            textView.text = "Enter your message.."
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
}
