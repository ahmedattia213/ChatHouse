//
//  FirebaseHelper.swift
//  ChatHouse
//
//  Created by Ahmed Amr on 2/10/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import Foundation
import FirebaseDatabase

let FirebaseMessagesKey = "messages"
let FirebaseUsersKey = "users"
let FireBaseStorageImagesKey = "myProfileImages"

class FirebaseHelper {
    static func fetchCurrentUserWithUid(uid: String, completionHandler: @escaping (User) -> Void) {
        let currentUser = User()
        let dbref = Database.database().reference().child(FirebaseUsersKey).child(uid)
        dbref.observe(DataEventType.value) { (snapshot) in
            let snapshotValue = snapshot.value as? [String: AnyObject] ?? [:]
            currentUser.setValuesForKeys(snapshotValue)
            completionHandler(currentUser)
        }
    }
}
