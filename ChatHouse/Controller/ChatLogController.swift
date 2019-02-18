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
    var containerViewHeightConstraint: NSLayoutConstraint?

    var user: User? {
        didSet {
            navigationItem.title = user?.name
            setupNavBarWithUser(user: user!)
            retrieveUserMessages()
        }

    }
    var messages = [Message]()

    func retrieveUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let userMessagesRef = Database.database().reference().child(FirebaseUserMessagesKey).child(uid)
        userMessagesRef.observe(.childAdded) { (snapshot) in
               let messageId = snapshot.key
               let messageRef = Database.database().reference().child(FirebaseMessagesKey).child(messageId)
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                let messagesDictionary = snapshot.value as? [String: AnyObject] ?? [:]
                let message = Message()
                message.setValuesForKeys(messagesDictionary)
                if message.chatPartnerId() == self.user?.id {
                    self.messages.append(message)
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }

            })

        }
    }

    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: view.frame.height)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: chatCellId, for: indexPath) as? ChatMessageCell
        let message = messages[indexPath.row]
        setupMessageCellWithMessage(cell!, message)
        return cell!
    }

    private func setupMessageCellWithMessage(_ cell: ChatMessageCell, _ message: Message) {
        cell.messageTextView.text = message.message
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message.message!).width + 32
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
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellheight = 80
        if let text = messages[indexPath.row].message {
            cellheight = Int(estimateFrameForText(text: text).height) + 20
        }
        return CGSize(width: Int(view.frame.width), height: cellheight)
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    func setupNavBarWithUser(user: User) { //HOW Dupplication ezay a7elo
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

    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        let img = UIImage(named: "newMessage")?.withRenderingMode(.alwaysOriginal)
        button.setImage(img, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(handleSendButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
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
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        self.hideKeyboard()
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: chatCellId)
        collectionView.backgroundColor = .white
        setupInputComponentsConstraints()

    }

    func setupInputComponentsConstraints() {
        view.addSubview(containerView)
        containerView.backgroundColor = .white
        containerView.addSubview(sendButton)
        containerView.addSubview(chatTextView)
        containerView.addSubview(separatorLineView)
        //containerView : x,y,width,height
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: 50)
        containerViewHeightConstraint?.isActive = true
        //sendButton : x,y,width,height
        sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        sendButton.topAnchor.constraint(equalTo: separatorLineView.topAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 35).isActive = true

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
        print("edaas 3lya")

        let fromId = Auth.auth().currentUser?.uid
        let toId = user!.id
        let ref = Database.database().reference().child(FirebaseMessagesKey).childByAutoId()
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let values = ["message": self.chatTextView.text!, "senderId": fromId!, "receiverId": toId!, "timestamp": timestamp ] as [String: AnyObject]
        ref.updateChildValues(values) { (error, reference) in
            if error != nil {
                print(error!)
                return
            }
            let userMessagesRef = Database.database().reference().child(FirebaseUserMessagesKey).child(fromId!)
            let messageId = ref.key
            userMessagesRef.updateChildValues([messageId!: "done"])
            let receiverMessageRef = Database.database().reference().child(FirebaseUserMessagesKey).child(toId!)
            receiverMessageRef.updateChildValues([messageId!: "done"])
        }
        self.chatTextView.text = ""
    }
}

extension ChatLogController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {

        UIView.animate(withDuration: 0.3) {
            self.containerViewHeightConstraint?.constant = 300
        }
        if   textView.text == "Enter your message.." && textView.textColor == .lightGray {
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
        if !(writtenString == "" || notAllowedtext.isSuperset(of: writtenText)) {
            sendButton.isHidden = false
                    } else {
            sendButton.isHidden = true
        }

    }
    func textViewDidEndEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.3) {
            self.containerViewHeightConstraint?.constant = 50
        }

        if textView.text == "" {
            textView.font = UIFont.systemFont(ofSize: 12)
            textView.text = "Enter your message.."
            textView.textColor = .lightGray
        }

        textView.resignFirstResponder()
    }
}
