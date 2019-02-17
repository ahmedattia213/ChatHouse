//
//  NewMessageController.swift
//  ChatHouse
//
//  Created by Ahmed Amr on 1/25/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
    var messagesController : MessagesController?
   
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.cellID)
        fetchUsers()
    }

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

    func fetchProfileImageWithCurrentUid(uid: String) -> UIImage {
        var image: UIImage?
        let url = Database.database().reference().child(FirebaseUsersKey).child(uid)
        url.observe(DataEventType.value) { (snapshot) in
            let snapshotValue = snapshot.value as? [String: AnyObject] ?? [:]
            let profileImageURLString = snapshotValue["profileImageUrl"] as! String
            image = profileImageURLString.getImageWithUrl().withRenderingMode(.alwaysOriginal)
        }
        return image ?? UIImage()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.cellID, for: indexPath) as? UserCell
        let user = users[indexPath.row]
        cell?.textLabel?.text = user.name
        cell?.detailTextLabel?.text = user.email
        if let profileImageUrl = user.profileImageUrl {
            cell?.profileImageView.retrieveDataFromUrl(urlString: profileImageUrl)
        }
        return cell!
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            let user = self.users[indexPath.row]
            self.messagesController?.showChatLogControllerForUser(user: user)

        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }

  

}
