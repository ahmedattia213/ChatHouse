//
//  NewMessageController+handlers.swift
//  ChatHouse
//
//  Created by Ahmed Amr on 2/26/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit
import Firebase

extension NewMessageController {
    
    @objc func handleImageClicking() {
        print("image clicked")
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func fetchUsers() {
        let usersRef = Database.database().reference().child(FirebaseUsersKey)
        usersRef.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as? [String: AnyObject] ?? [:]
            let user = User()
            user.setValuesForKeys(snapshotValue)
            user.id = snapshot.key
            if let currentId = Auth.auth().currentUser?.uid {
                user.id!.caseInsensitiveCompare(currentId) == ComparisonResult.orderedSame ?  nil : self.users.append(user)
            } else {
                self.users.append(user)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
