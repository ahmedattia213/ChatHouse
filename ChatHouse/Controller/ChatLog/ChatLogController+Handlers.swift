//
//  ChatLogController+Handlers.swift
//  ChatHouse
//
//  Created by Ahmed Amr on 2/20/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

extension ChatLogController: ImagePickerDelegate {

    func retrieveUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid, let toId = user?.id else {
            return
        }
        let userMessagesRef = Database.database().reference().child(FirebaseUserMessagesKey).child(uid).child(toId)
        userMessagesRef.observe(.childAdded) { (snapshot) in
            let messageId = snapshot.key
            let messageRef = Database.database().reference().child(FirebaseMessagesKey).child(messageId)
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                let messagesDictionary = snapshot.value as? [String: AnyObject] ?? [:]
                self.messages.append(Message(dictionary: messagesDictionary))
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.scrollToBottomCollectionView()
                }

            })

        }
    }

    @objc func dismissKeyboardWhenTappedAround() {
        collectionView.endEditing(true)
        chatTextView.resignFirstResponder()
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardHeight = keyboardFrame!.height

        let keyboardAnimationDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        self.containerViewBottomAnchor?.constant = -keyboardHeight
        UIView.animate(withDuration: keyboardAnimationDuration!) {
            self.view.layoutIfNeeded()
        }
    }
        @objc func keyboardWillHide(_ notification: Notification) {
            let keyboardAnimationDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
            containerViewBottomAnchor?.constant = 0
            UIView.animate(withDuration: keyboardAnimationDuration!) {
                self.view.layoutIfNeeded()
            }
        }

    @objc func handleSendImageButton() {
       self.imagePicker.present(from: self.view)
    }
       @objc func handleSendButton() {
        sendMessage(imageUrl: nil, image: nil, textViewMessage: self.chatTextView.text)
    }

    private func sendMessage(imageUrl: String?, image: UIImage?, textViewMessage: String?) {
        let fromId = Auth.auth().currentUser?.uid
        let toId = user!.id
        let ref = Database.database().reference().child(FirebaseMessagesKey).childByAutoId()
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let values = imageUrl == nil ? ["text": textViewMessage!, "senderId": fromId!, "receiverId": toId!, "timestamp": timestamp ] : [ "senderId": fromId!, "receiverId": toId!, "timestamp": timestamp, "imageUrl": imageUrl!, "imageWidth": image!.size.width, "imageHeight": image!.size.height ]
        self.chatTextView.text = nil
        ref.updateChildValues(values) { (error, reference) in
            if error != nil {
                print(error!)
                return
            }
            let userMessagesRef = Database.database().reference().child(FirebaseUserMessagesKey).child(fromId!).child(toId!)
            let messageId = ref.key
            userMessagesRef.updateChildValues([messageId!: "done"])
            let receiverMessageRef = Database.database().reference().child(FirebaseUserMessagesKey).child(toId!).child(fromId!)
            receiverMessageRef.updateChildValues([messageId!: "done"])
        }

    }

    func didSelect(image: UIImage?) {
        uploadToFirebaseStorgageWithImage(image: image!)
    }

    private func uploadToFirebaseStorgageWithImage(image: UIImage) {
        let imageId = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child(FirebaseStorageMessageImagesKey).child("\(imageId).jpg")
        let uploadData = UIImage.jpegData(image)(compressionQuality: 0.2)
        storageRef.putData(uploadData!, metadata: nil) { (_, error) in
            if error != nil {
                print(error!)
                return
            }
               storageRef.downloadURL(completion: { (url, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let imageUrl = url?.absoluteString {
                    self.sendMessageWithImageUrl(imageUrl: imageUrl, image: image)
                }

            })

            }

        }
    private func sendMessageWithImageUrl(imageUrl: String, image: UIImage) {
        sendMessage(imageUrl: imageUrl, image: image, textViewMessage: nil)
    }

    }
