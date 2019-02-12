//
//  LOgi.swift
//  ChatHouse
//
//  Created by Ahmed Amr on 2/4/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

import FirebaseStorage

extension LoginController {

    func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else { return }
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error!)
                return
            }
            guard let uid =  user?.user.uid else { return }
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child(FireBaseStorageImagesKey).child("\(imageName).png")

            if let profileImage = self.profileImageView.image, let uploadData = UIImage.jpegData(profileImage)(compressionQuality: 0.1) {
                storageRef.putData(uploadData, metadata: nil, completion: { (_, err) in
                    if err != nil {
                        print(err!)
                        return
                    }
                    storageRef.downloadURL(completion: { (profImageUrl, error) in
                        if error != nil {
                            print(error!)
                            return
                        }
                        let values = ["name": name, "email": email, "profileImageUrl": profImageUrl!.absoluteString]
                        self.registerUserIntoDatabaseWithUid(uid: uid, values: values as [String: AnyObject] )
                    })

                })

            }
        }

    }

    private func registerUserIntoDatabaseWithUid(uid: String, values: [String: AnyObject]) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let usersRef = ref.child(FirebaseUsersKey).child(uid)
        usersRef.updateChildValues(values) { (err, _) in
            if err != nil {
                print(err!)
                return
            }
            let user = User()
            user.setValuesForKeys(values)
            self.messagesController?.setupNavBarWithUser(user: user)
            self.dismiss(animated: true, completion: nil)
        }
    }

    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (AuthDataResult, error) in
            if error != nil {
                return
            }
            if let uid = AuthDataResult?.user.uid {
                FirebaseHelper.fetchCurrentUserWithUid(uid: uid, completionHandler: { (currentUser) in
                    self.messagesController?.setupNavBarWithUser(user: currentUser)
                    self.dismiss(animated: true, completion: nil)
                })
            }
        }
    }

    @objc func handleRegisterLoginButton() {
        loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? handleRegister() : handleLogin()
    }

    @objc func handleImageClick() {
        print("ew3a")
        self.imagePicker.present(from: self.view)
    }

    @objc func handleLoginRegisterChange() {

        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)

        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ?  150 : 100

        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/3 : 0)
        nameTextFieldHeightAnchor?.isActive = true

        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/3 : 1/2 )
        emailTextFieldHeightAnchor?.isActive = true
    }
}
