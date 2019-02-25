//
//  Message.swift
//  ChatHouse
//
//  Created by Ahmed Amr on 2/11/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import Foundation
import FirebaseAuth

class Message: NSObject {

    @objc var text: String?
    @objc var receiverId: String?
    @objc var senderId: String?
    @objc var timestamp: NSNumber?
    @objc var imageUrl: String?
    @objc var imageWidth: NSNumber?
    @objc var imageHeight: NSNumber?
    @objc var videoUrl: String?

    init(dictionary: [String: AnyObject]) {
        super.init()
        text = dictionary["text"] as? String
        receiverId = dictionary["receiverId"] as? String
        senderId = dictionary["senderId"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
        imageUrl = dictionary["imageUrl"] as? String
        imageWidth = dictionary["imageWidth"] as? NSNumber
        imageHeight = dictionary["imageHeight"] as? NSNumber
        videoUrl = dictionary["videoUrl"] as? String
    }
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.text == rhs.text && lhs.receiverId == rhs.receiverId
            && lhs.senderId == rhs.senderId
            && lhs.timestamp == rhs.timestamp
            && lhs.imageUrl == rhs.imageUrl
            && lhs.imageWidth == rhs.imageWidth
            && lhs.imageHeight == rhs.imageHeight
            && lhs.videoUrl == rhs.videoUrl
    }
    func chatPartnerId() -> String? {
       return  receiverId == Auth.auth().currentUser?.uid ? senderId : receiverId
    }
}
struct DictionaryKey: Hashable {
    var receiverId: String
    var senderId: String
}
