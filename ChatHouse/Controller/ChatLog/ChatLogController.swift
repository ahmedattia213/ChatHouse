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

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let chatCellId = "chatCellId"
    var containerViewBottomAnchor: NSLayoutConstraint?
    var imagePicker : ImagePicker!
    var imagePicked : UIImage?
    
    var user: User? {
        didSet {
            navigationItem.title = user?.name
            setupNavBarWithUser(user!)
            retrieveUserMessages()
        }
        
    }
    var messages = [Message]()
    
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: view.frame.height)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    func setupNavBarWithUser(_ user: User) { //HOW Dupplication ezay a7elo
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        self.navigationItem.titleView = titleView
        
        let containerView = UIView()
        titleView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let profileImageView = UIImageView()
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.retrieveDataFromUrl(urlString: profileImageUrl)
        }
        containerView.addSubview(profileImageView)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 20
        
        profileImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.text = user.name
        containerView.addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor ).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
    }
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        let img = UIImage(named: "sendMessage3")?.withRenderingMode(.alwaysOriginal)
        button.setImage(img, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(handleSendButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    let sendImageButton : UIButton = {
       let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let img = UIImage(named: "sendImage")?.withRenderingMode(.alwaysOriginal)
        button.setImage(img, for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(handleSendImageButton), for: .touchUpInside)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        collectionView.alwaysBounceVertical = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardWhenTappedAround))
        collectionView.addGestureRecognizer(tap)
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.hideKeyboard()
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: chatCellId)
        collectionView.backgroundColor = .white
        collectionView.keyboardDismissMode = .interactive
        setupKeyboardObservers()
        
        
    }
    
    
    lazy var inputContainerView : UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor = .white
        containerView.addSubview(sendButton)
        containerView.addSubview(chatTextView)
        containerView.addSubview(separatorLineView)
        containerView.addSubview(sendImageButton)
        containerView.addSubview(textViewAndImageLineSeparator)
        
        //sendImageButton: x,y,width,height
        sendImageButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        sendImageButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendImageButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        sendImageButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        //sendButton: x,y,width,height
        sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        //chatTextView : x,y,width,height
        chatTextView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8).isActive = true
        chatTextView.leadingAnchor.constraint(equalTo: textViewAndImageLineSeparator.trailingAnchor, constant: 3).isActive = true
        chatTextView.topAnchor.constraint(equalTo: separatorLineView.topAnchor).isActive = true
        chatTextView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        //separatorLineView: x,y,width,height
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //separatorLineView: x,y,width,height
        textViewAndImageLineSeparator.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        textViewAndImageLineSeparator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        textViewAndImageLineSeparator.leadingAnchor.constraint(equalTo: sendImageButton.trailingAnchor).isActive = true
        
        return containerView
       
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self )
    }
    
    func setupKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
     func scrollToBottomCollectionView(){
        let indexPath = IndexPath(item: self.messages.count - 1 , section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: chatCellId, for: indexPath) as? ChatMessageCell
        let message = messages[indexPath.row]
        setupMessageCellWithMessage(cell!, message)
        return cell!
    }
    
    private func setupMessageCellWithMessage(_ cell: ChatMessageCell, _ message: Message) {
        cell.messageTextView.text = message.text
    
        if message.receiverId == Auth.auth().currentUser?.uid {
            cell.profileImageVIew.isHidden = false
            if let profileImageUrl = self.user?.profileImageUrl {
                cell.profileImageVIew.retrieveDataFromUrl(urlString: profileImageUrl )
            }
            cell.bubbleTrailingAnchor?.isActive = false
            cell.bubbleLeadingAnchor?.isActive = true
            cell.bubbleView.backgroundColor = ChatMessageCell.bubbleViewGrayColor
            cell.bubbleView.clipsToBounds = true
            cell.bubbleView.layer.cornerRadius = 15
            cell.messageTextView.textColor = .black
            
        } else {
            cell.profileImageVIew.isHidden = true
            cell.bubbleLeadingAnchor?.isActive = false
            cell.bubbleTrailingAnchor?.isActive = true
            cell.bubbleView.backgroundColor = ChatMessageCell.bubbleViewBlueColor
            cell.bubbleView.clipsToBounds = true
            cell.bubbleView.layer.cornerRadius = 15
            cell.messageTextView.textColor = .white
        }
        
        if let text = message.text {
            cell.messageImageView.isHidden = true
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: text).width + 32
            cell.messageTextView.isHidden = false
            
        } else if message.imageUrl != nil {
            cell.messageTextView.isHidden = true
            cell.bubbleView.backgroundColor = .clear
            cell.messageImageView.isHidden = false
            cell.messageImageView.retrieveDataFromUrl(urlString: message.imageUrl!)
            cell.bubbleWidthAnchor?.constant = 200
        }
        
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellheight = 80
        let message = messages[indexPath.row]
        if let text = message.text {
            cellheight = Int(estimateFrameForText(text: text).height) + 20
        } else if let imageWidth = message.imageWidth , let imageHeight = message.imageHeight {
            cellheight = Int((imageHeight.floatValue/imageWidth.floatValue) * 200 )
        }
        return CGSize(width: Int(view.frame.width), height: cellheight)
    }
}








extension ChatLogController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.scrollToBottomCollectionView()
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
