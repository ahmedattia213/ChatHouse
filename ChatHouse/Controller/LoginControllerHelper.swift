//
//  LoginControllerHelper.swift
//  ChatHouse
//
//  Created by Ahmed Amr on 1/17/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

extension LoginController {
    
    
    @objc func handleChooseLogin(){
        chooseLogin.backgroundColor = .white
        chooseLogin.setTitleColor(UIColor(hexRGB: 0x4376CF), for: .normal)
        
        chooseRegister.backgroundColor = UIColor(hexRGB: 0x4376CF)
        chooseRegister.setTitleColor(.white, for: .normal)
        loginRegisterButton.setTitle("Login", for: .normal)
        
    }
    
    @objc func handleChooseRegister(){
        chooseRegister.backgroundColor = .white
        chooseRegister.setTitleColor(UIColor(hexRGB: 0x4376CF), for: .normal)
        
        chooseLogin.backgroundColor = UIColor(hexRGB: 0x4376CF)
        chooseLogin.setTitleColor(.white, for: .normal)
        loginRegisterButton.setTitle("Register", for: .normal)
        
    }
    
    @objc func handleRegister(){
        guard let email = emailTextField.text , let password = passwordTextField.text , let name = nameTextField.text else {
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error!)
                return
            }
            guard let uid =  user?.user.uid else {
                return
            }
            var ref: DatabaseReference!
            ref = Database.database().reference()
            
            let usersRef = ref.child("users").child(uid)
            let values = ["name": name , "email": email]
            usersRef.updateChildValues(values) { (err, ref) in
                if err != nil {
                    print(err!)
                    return
                }
                print("Done2")
            }
            
            print("DONE1")
            
        }
        
        
        
    }
    
    
    func setupInputsContainer(){
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        //x,y,width,height
        //
        nameTextField.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor , constant: 10).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: inputsContainerView.trailingAnchor, constant: -10).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor , multiplier: 1/3).isActive = true
        
        
        inputsContainerView.addSubview(nameSeparatorView)
        nameSeparatorView.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor).isActive = true
        nameSeparatorView.trailingAnchor.constraint(equalTo: inputsContainerView.trailingAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        
        inputsContainerView.addSubview(emailTextField)
        emailTextField.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor, constant: 10).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: inputsContainerView.trailingAnchor, constant: -10).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameSeparatorView.bottomAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor).isActive = true
        
        
        
        
        inputsContainerView.addSubview(emailSeparatorView)
        emailSeparatorView.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor).isActive = true
        emailSeparatorView.trailingAnchor.constraint(equalTo: inputsContainerView.trailingAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        inputsContainerView.addSubview(passwordTextField)
        passwordTextField.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor, constant: 10).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: inputsContainerView.trailingAnchor, constant: -10).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailSeparatorView.bottomAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor).isActive = true
        
    }
    func setupLoginRegisterButton(){
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor , constant: 8).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupProfileImageView (){
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        profileImageView.bottomAnchor.constraint(equalTo: stackView.topAnchor , constant: -10).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setupChooseLoginRegister(){
        
        stackView = UIStackView(arrangedSubviews: [chooseRegister,chooseLogin])
        view.addSubview(stackView)
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
       
        
        // hanieeeeeen :p
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -6).isActive = true
        stackView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
       
      
        chooseRegister.layer.borderColor = UIColor.white.cgColor
        chooseRegister.layer.borderWidth = 0.5
        
        
      
        chooseLogin.layer.borderColor = UIColor.white.cgColor
        chooseLogin.layer.borderWidth = 0.5
        
    }
}


class UIButtonRoundTopRightBottomRight: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = [.layerMaxXMinYCorner , .layerMaxXMaxYCorner]
    }
}

class UIButtonRoundTopLeftBottomLeft : UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
}



//stackView.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor , constant: -6).isActive = true
//stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//stackView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
//stackView.heightAnchor.constraint(equalToConstant: 30).isActive = true
//
