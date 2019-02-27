//
//  ChatInputContainerView.swift
//  ChatHouse
//
//  Created by Ahmed Amr on 2/27/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit

class ChatInputContainerView: UIView, UITextViewDelegate {
    var chatLogController: ChatLogController? {
        didSet {
            sendButton.addTarget(chatLogController, action: #selector(chatLogController?.handleSendButton), for: .touchUpInside)
            sendImageButton.addTarget(chatLogController, action: #selector(chatLogController?.handleSendImageButton), for: .touchUpInside)

        }
    }
        let sendButton: UIButton = {
            let button = UIButton(type: .system)
            button.backgroundColor = .white
            let img = UIImage(named: "sendMessage3")?.withRenderingMode(.alwaysOriginal)
            button.setImage(img, for: .normal)
            button.imageView?.contentMode = .scaleAspectFill
            button.translatesAutoresizingMaskIntoConstraints = false
            button.isHidden = true
            return button
        }()
    //inputContainerView
        let sendImageButton: UIButton = {
           let button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            let img = UIImage(named: "sendImage")?.withRenderingMode(.alwaysOriginal)
            button.setImage(img, for: .normal)
            button.imageView?.contentMode = .scaleToFill
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

        let textViewAndImageLineSeparator: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(hexRGB: 0xDCDCDC)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(sendButton)
        addSubview(chatTextView)
        addSubview(separatorLineView)
        addSubview(sendImageButton)
        addSubview(textViewAndImageLineSeparator)

        //sendImageButton: x,y,width,height
        sendImageButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        sendImageButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sendImageButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        sendImageButton.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

        //sendButton: x,y,width,height
        sendButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        sendButton.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

        //chatTextView : x,y,width,height
        chatTextView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8).isActive = true
        chatTextView.leadingAnchor.constraint(equalTo: textViewAndImageLineSeparator.trailingAnchor, constant: 3).isActive = true
        chatTextView.topAnchor.constraint(equalTo: separatorLineView.topAnchor).isActive = true
        chatTextView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        //separatorLineView: x,y,width,height
        separatorLineView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        //separatorLineView: x,y,width,height
        textViewAndImageLineSeparator.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        textViewAndImageLineSeparator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        textViewAndImageLineSeparator.leadingAnchor.constraint(equalTo: sendImageButton.trailingAnchor).isActive = true

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        chatLogController?.scrollToBottomCollectionView()
        if  textView.text == "Enter your message.." && textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
            textView.font = UIFont.systemFont(ofSize: 14)
        }
        textView.becomeFirstResponder()
    }

    func textViewDidChange(_ textView: UITextView) {
        let notAllowedtext = CharacterSet.init(charactersIn: " ")
        let writtenString = textView.text!
        let writtenText = CharacterSet.init(charactersIn: writtenString)
        if !(writtenString == "Enter your message.." || writtenString == "" || notAllowedtext.isSuperset(of: writtenText)) {
            sendButton.isHidden = false
        } else {
            sendButton.isHidden = true
            textView.text = ""
            textView.textColor = .black
            textView.font = UIFont.systemFont(ofSize: 14)
        }

    }
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.text = "Enter your message.."
        textView.textColor = .lightGray
        textView.resignFirstResponder()
    }

}
