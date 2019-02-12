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
    let cellID = "cellid"
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
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
        usersRef.observe(DataEventType.value) { (snapshot) in
            let snapshotValue = snapshot.value as? [String: AnyObject] ?? [:]

            for snap in snapshotValue {
                let user = User()
                user.id = snap.key
                user.setValuesForKeys(snap.value as! [String: AnyObject])
                user.email?.caseInsensitiveCompare((Auth.auth().currentUser?.email)!) == ComparisonResult.orderedSame ?  nil : self.users.append(user)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? UserCell
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

    class UserCell: UITableViewCell {

        override func layoutSubviews() {
            super.layoutSubviews()
            textLabel?.frame = CGRect(x: profileImageView.frame.maxX + 10, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
            detailTextLabel?.frame = CGRect(x: profileImageView.frame.maxX + 10, y: detailTextLabel!.frame.origin.y + 0.5, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
        }
        let profileImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 24
            imageView.layer.cornerRadius = 20

            return imageView
        }()
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
            addSubview(profileImageView)
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
            profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
            profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

}
