//
//  FirebaseHelper.swift
//  ChatHouse
//
//  Created by Ahmed Amr on 2/10/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseHelper {
    static func fetchCurrentUserWithUid(uid: String, completionHandler: @escaping (User) -> Void) {
        let user = User()
        let dbref = Database.database().reference().child("users").child(uid)
        dbref.observe(DataEventType.value) { (snapshot) in
            let snapshotValue = snapshot.value as? [String: AnyObject] ?? [:]
            user.setValuesForKeys(snapshotValue)
            completionHandler(user)
        }
    }
}
