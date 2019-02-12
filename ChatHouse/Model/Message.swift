//
//  Message.swift
//  ChatHouse
//
//  Created by Ahmed Amr on 2/11/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import Foundation

class Message : NSObject {
    @objc var message: String?
    @objc var receiverId: String?
    @objc var senderId: String?
    @objc var timestamp: NSNumber?
}
