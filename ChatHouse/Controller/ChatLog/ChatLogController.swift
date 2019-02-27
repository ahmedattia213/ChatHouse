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
    var startingFrame: CGRect?
    var blackBackground : UIView?
    var startingImageView: UIImageView?
    let chatCellId = "chatCellId"
    var containerViewBottomAnchor: NSLayoutConstraint?
    var imagePicker: ImagePicker!
    var imagePicked: UIImage?
    var nameLabel = UILabel()
    
    var user: User? {
        didSet {
            navigationItem.title = user?.name
            setupNavBarWithUser(user!)
            retrieveMessages()
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

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        collectionView.alwaysBounceVertical = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardWhenTappedAround))
        collectionView.addGestureRecognizer(tap)
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.hideKeyboardWhenTappedAround()
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: chatCellId)
        collectionView.backgroundColor = .white
        collectionView.keyboardDismissMode = .interactive
    }

    lazy var inputContainerView: ChatInputContainerView = {
        let containerView = ChatInputContainerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        containerView.chatLogController = self
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


     func scrollToBottomCollectionView() {
        if messages.count > 0 {
            let indexPath = IndexPath(item: messages.count - 1, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: chatCellId, for: indexPath) as? ChatMessageCell
        cell?.chatLogController = self
        let message = messages[indexPath.row]
        cell?.message = message
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
            cell.playButton.isHidden = true
            cell.messageImageView.isHidden = true
            cell.messageTextView.isHidden = false
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: text).width + 32

        } else if message.imageUrl != nil {
            cell.playButton.isHidden = true
            cell.messageTextView.isHidden = true
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = .clear
            cell.messageImageView.retrieveDataFromUrl(urlString: message.imageUrl!)
            cell.bubbleWidthAnchor?.constant = 200
            cell.playButton.isHidden = message.videoUrl == nil
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
        } else if let imageWidth = message.imageWidth, let imageHeight = message.imageHeight {
            cellheight = Int((imageHeight.floatValue/imageWidth.floatValue) * 200 )
        }
        return CGSize(width: Int(view.frame.width), height: cellheight)
    }

    func performZoomInForStartingImageView(_ startingImageView: UIImageView){
         startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
         self.startingImageView = startingImageView
         self.startingImageView?.isHidden = true
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removePictureaAndBackground)))
         if let keyWindow = UIApplication.shared.keyWindow {
            blackBackground = UIView(frame: keyWindow.frame)
            blackBackground?.backgroundColor = .black
            keyWindow.addSubview(blackBackground!)
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackBackground?.alpha = 1
                self.inputContainerView.alpha = 0
                let height = keyWindow.frame.width * (self.startingFrame!.height / self.startingFrame!.width)
                zoomingImageView.frame =  CGRect(x: 0, y: 0 , width: keyWindow.frame.width , height: height)
                zoomingImageView.center = keyWindow.center
            }, completion: nil)
    
        }
        
    }
    
}

