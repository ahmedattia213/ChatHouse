//
//  ViewController.swift
//  ChatHouse
//
//  Created by Ahmed Amr on 1/16/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class MessagesController: UITableViewController {
    var timer: Timer?
    var myMessages = [Message]()
    var messagesDictionary = [String: Message]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.cellID)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))

        let img = UIImage(named: "newMessage")?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(handleNewMessage))
    }

    func popCurrentMessages() {
        myMessages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myMessages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.cellID) as? UserCell
        cell?.message = myMessages[indexPath.row]
        return cell!
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = myMessages[indexPath.row]
        let partnerId = message.chatPartnerId()
        if let id = partnerId {
            FirebaseHelper.fetchUserWithUid(id) { (partner) in
                self.showChatLogControllerForUser(user: partner)
            }
        }

    }
    func retrieveUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child(FirebaseUserMessagesKey).child(uid)
        ref.observe(.childAdded) { (snapshot) in
            let userId = snapshot.key
            Database.database().reference().child(FirebaseUserMessagesKey).child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
                let messageId = snapshot.key
                self.fetchMessagesWithMessageId(messageId)
            })
        }
    }

    private func fetchMessagesWithMessageId(_ messageId: String) {
        let messagesRef = Database.database().reference().child(FirebaseMessagesKey).child(messageId)
        messagesRef.observeSingleEvent(of: .value, with: { (messageSnapshot) in
            let messageSnapshotValue = messageSnapshot.value as? [String: AnyObject] ?? [:]
            let message = Message(dictionary: messageSnapshotValue)
            if let partnerId = message.chatPartnerId() {
                var newerMessage: Message?
                if let olderMessage = self.messagesDictionary[partnerId] {
                    newerMessage = message.timestamp!.intValue > olderMessage.timestamp!.intValue ? message : olderMessage
                }
                self.messagesDictionary[partnerId] = newerMessage ?? message
                self.myMessages = Array(self.messagesDictionary.values)
                self.myMessages.sort(by: { (message1, message2) -> Bool in
                    return message1.timestamp!.intValue > message2.timestamp!.intValue
                })

                //fix reloading too much
                self.reloadTableViewWithTimer()

            }

        })
    }
    private func reloadTableViewWithTimer() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTableView), userInfo: nil, repeats: false)
    }

    @objc func handleReloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        checkIfUserLoggedIn()
        retrieveUserMessages()
        //myMessages.printArrayElements()
        // messagesDictionary.forEach { print("\($0): \(String(describing: $1.message))") }
    }
    @objc func handleNewMessage() {
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }

    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
            SVProgressHUD.showError(withStatus: "\(logoutError.localizedDescription)")
            SVProgressHUD.dismiss(withDelay: 1.2)
            return
        }
        let loginController = LoginController()
        loginController.messagesController = self
        self.popCurrentMessages()
        present(loginController, animated: true, completion: nil)
    }

    func checkIfUserLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            setupNavBarTitle()

        }
    }

    func setupNavBarTitle() {

        let myUser = Database.database().reference().child(FirebaseUsersKey).child(Auth.auth().currentUser!.uid)
        myUser.observe(DataEventType.value) { (snapshot) in
            if let snapshotValue = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.setValuesForKeys(snapshotValue)
                self.setupNavBarWithUser(user)
            }
        }

    }

    func setupNavBarWithUser(_ user: User) {
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        self.navigationItem.titleView = titleView

        let containerView = UIView()
        titleView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false

        let profileImageView = UIImageView()
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.retrieveDataFromUrl(urlString: profileImageUrl)
        }
        containerView.addSubview(profileImageView)

        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 20

        profileImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true

        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.text = user.name
        containerView.addSubview(nameLabel)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor ).isActive = true

        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true

    }

    @objc func showChatLogControllerForUser(user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }

}

class MessageCell: UITableViewCell {
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //  imageView.image = UIImage(named: "anyface")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 24
        return imageView
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: profileImageView.frame.maxX + 8, y: textLabel!.frame.origin.y, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: profileImageView.frame.maxX + 8, y: detailTextLabel!.frame.origin.y, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)

    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Array {
    func printArrayElements() {
        for element in self as! [Message] {
            print(element.text!)
        }
        print()
    }
}
