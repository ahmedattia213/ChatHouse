//
//  MessagesController+handlers.swift
//  ChatHouse
//
//  Created by Ahmed Amr on 2/26/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

extension MessagesController {
    @objc func handleReloadTableView() {
        self.myMessages = Array(self.messagesDictionary.values)
        self.myMessages.sort(by: { (message1, message2) -> Bool in
            return message1.timestamp!.intValue > message2.timestamp!.intValue
        })
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
    @objc func showChatLogControllerForUser(user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
      
    }

    func popCurrentMessages() {
        myMessages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
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
        ref.observe(.childRemoved) { (snapshot) in
            self.messagesDictionary.removeValue(forKey: snapshot.key)
            self.reloadTableViewWithTimer()
        }
    }
    func checkIfUserLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            setupNavBarTitle()

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
                    newerMessage = message.timestamp!.int32Value > olderMessage.timestamp!.int32Value ? message : olderMessage
                }
                self.messagesDictionary[partnerId] = newerMessage ?? message
                //fix reloading too much
                self.reloadTableViewWithTimer()

            }

        })
    }
}
