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
import SVProgressHUD
import AVFoundation

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
    
    @objc func handleSendImageButton() {
        self.imagePicker.present(from: self.view)
    }
    @objc func handleSendButton() {
        let properties = ["text": self.chatTextView.text]
        sendMessageWithProperties(properties as [String : AnyObject])
    }
    
    private func sendMessageWithProperties(_ properties: [String: AnyObject]) {
        let fromId = Auth.auth().currentUser?.uid
        let toId = user!.id
        let ref = Database.database().reference().child(FirebaseMessagesKey).childByAutoId()
        let timestamp = Int(NSDate().timeIntervalSince1970)
        
        var values =  ["senderId": fromId!, "receiverId": toId!, "timestamp": timestamp] as [String : AnyObject]
        properties.forEach({values[$0] = $1})
        
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
    
    func didSelect(selectedMedia: Any?) {
        if let image = selectedMedia as? UIImage {
            uploadToFirebaseStorgageWithImage(image: image) { (url) in
                self.sendMessageWithImageUrl(imageUrl: url, image: image)
            }
        }
        else if let videoUrl = selectedMedia as? URL {
            handleVideoSelectedWithUrl(videoUrl)
        }
    }
    
    private func handleVideoSelectedWithUrl(_ fileUrl: URL){
        let urlId = UUID().uuidString + ".mov"
        let storageRef = Storage.storage().reference().child(FirebaseStorageMessageVideosKey).child(urlId)
        let uploadVideoTask = storageRef.putFile(from: fileUrl, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error!)
                return
            }
            storageRef.downloadURL(completion: { (url, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let thumbnailImage = self.thumbnailImageForFileUrl(fileUrl: fileUrl), let videoUrl = url {
                    self.uploadToFirebaseStorgageWithImage(image: thumbnailImage, completion: { (imageUrl) in
                        let properties =  ["imageUrl": imageUrl, "imageWidth": thumbnailImage.size.width, "imageHeight": thumbnailImage.size.height ,"videoUrl": videoUrl.absoluteString] as [String: AnyObject]
                        self.sendMessageWithProperties(properties)
                    })
                }
            })
        }
        uploadVideoTask.observe(.progress) { (snapshot) in
            if let doubleFraction = snapshot.progress?.fractionCompleted {
                SVProgressHUD.showProgress(Float(doubleFraction), status: "sending \(Int(doubleFraction * 100))%")
            }
        }
        uploadVideoTask.observe(.success) { (snapshot) in
            SVProgressHUD.showSuccess(withStatus: "Sent")
            SVProgressHUD.dismiss(withDelay: 0.5)
        }
    }
    
    private func thumbnailImageForFileUrl(fileUrl: URL) -> UIImage? {
        let imageAsset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: imageAsset)
        do {
            let thumbnailCgImage = try imageGenerator.copyCGImage(at: CMTime(value: 1, timescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnailCgImage)
        } catch let err {
            print(err)
        }
        return nil
    }
    
    private func uploadToFirebaseStorgageWithImage(image: UIImage, completion: @escaping (_ imageUrl: String) -> Void) {
        let imageId = UUID().uuidString
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
                    completion(imageUrl)
                }
                
            })
        }
        
    }
    
    private func sendMessageWithImageUrl(imageUrl: String, image: UIImage) {
        let properties = ["imageUrl": imageUrl, "imageWidth": image.size.width, "imageHeight": image.size.height ] as [String : AnyObject]
        sendMessageWithProperties(properties)
    }
    
    @objc func removePictureaAndBackground(tapGesture: UITapGestureRecognizer ){
        if let zoomingOutImageView = tapGesture.view as? UIImageView {
            zoomingOutImageView.clipsToBounds = true
            zoomingOutImageView.layer.cornerRadius = 15
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomingOutImageView.frame = self.startingFrame!
                self.blackBackground?.alpha = 0
                self.inputContainerView.alpha = 1
            }) { (completed) in
                self.startingImageView?.isHidden = false
                zoomingOutImageView.removeFromSuperview()
            }
        }
    }
    
}
