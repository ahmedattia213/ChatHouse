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

    @objc var message: String?
    @objc var receiverId: String?
    @objc var senderId: String?
    @objc var timestamp: NSNumber?

    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.message == rhs.message && lhs.receiverId == rhs.receiverId
            && lhs.senderId == rhs.senderId
            && lhs.timestamp == rhs.timestamp
    }

    func chatPartnerId() -> String? {
       return  receiverId == Auth.auth().currentUser?.uid ? senderId : receiverId
    }
}

struct DictionaryKey: Hashable {
    var receiverId: String
    var senderId: String
}
