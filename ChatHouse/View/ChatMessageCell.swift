//
//  ChatMessageCell.swift
//  ChatHouse
//
//  Created by Ahmed Amr on 2/17/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit
import AVFoundation

class ChatMessageCell: UICollectionViewCell {
    
     var message: Message?
     static let bubbleViewBlueColor = UIColor(hexRGB: 0x2e8bed)
     static let bubbleViewGrayColor = UIColor(hexRGB: 0xdfdee6)
     var chatLogController : ChatLogController?
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()

    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.isEditable = false
        return textView
    }()
    
    lazy var playButton: UIButton = {
       let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.setImage(UIImage(named: "playVideo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlayButton), for: .touchUpInside)
        return button
    }()

    let profileImageVIew: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()

    lazy var messageImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.isHidden = true
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapToZoom)))
        return imageView
    }()

    @objc func handleTapToZoom(tapGesture: UITapGestureRecognizer){
        if message?.videoUrl != nil {
            return }
        
        if let imageView = tapGesture.view as? UIImageView  {
            chatLogController?.performZoomInForStartingImageView(imageView)
        }
        
    }
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    @objc func handlePlayButton(){
        if let userMessage = message , let urlString = userMessage.videoUrl, let url = URL(string: urlString) {
            player = AVPlayer(url: url)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = bubbleView.bounds
            bubbleView.layer.addSublayer(playerLayer!)
            player?.play()
            playButton.isHidden = true
            activityIndicatorView.startAnimating()
        }
        
    }
    
    override func prepareForReuse() {
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        playButton.isHidden = false
        activityIndicatorView.stopAnimating()
    }
    
    let bubbleView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        return view
    }()
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleTrailingAnchor: NSLayoutConstraint?
    var bubbleLeadingAnchor: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(profileImageVIew)
        addSubview(bubbleView)
        addSubview(messageTextView)
        bubbleView.addSubview(messageImageView)
        messageImageView.addSubview(playButton)
        messageImageView.addSubview(activityIndicatorView)
        
        profileImageVIew.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageVIew.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        profileImageVIew.widthAnchor.constraint(equalToConstant: 30).isActive = true
        profileImageVIew.heightAnchor.constraint(equalToConstant: 30).isActive = true

        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleTrailingAnchor = bubbleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        bubbleTrailingAnchor?.isActive = false
        bubbleLeadingAnchor = bubbleView.leadingAnchor.constraint(equalTo: profileImageVIew.trailingAnchor, constant: 3)
        bubbleLeadingAnchor?.isActive = false
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        playButton.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        activityIndicatorView.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        messageImageView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor).isActive = true
        messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true

        messageTextView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        messageTextView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 8 ).isActive = true
        messageTextView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -2).isActive = true
        messageTextView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
    
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
