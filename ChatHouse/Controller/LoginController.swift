//
//  LoginController.swift
//  ChatHouse
//
//  Created by Ahmed Amr on 1/16/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    
    let inputsContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
   
    let loginRegisterButton : UIButton = {
       let button = UIButton(type: .system)
        button.backgroundColor = UIColor(hexRGB: 0x4376CF)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleLoginRegisterButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
    let nameTextField : UITextField = {
    let textfield = UITextField()
        textfield.placeholder = "Enter your name"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    let emailTextField : UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter your email"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    let passwordTextField : UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter your password"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    let nameSeparatorView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexRGB: 0xDCDCDC)
        return view
    }()
    
    let emailSeparatorView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexRGB: 0xDCDCDC)
        return view
    }()
    
    let profileImageView : UIImageView = {
       let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "userProfile")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    @objc func handleLoginRegisterButton(){
    print("Handle")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexRGB: 0x4390bc)
     
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        setupInputsContainer()
        setupLoginRegisterButton()
        setupProfileImageView()
    }
    
    func setupInputsContainer(){
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        inputsContainerView.addSubview(nameTextField)
         // x (leading trailing), y(top), width((leading trailing) , height (inputs/3)
        nameTextField.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor , constant: 10).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: inputsContainerView.trailingAnchor, constant: -10).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor , multiplier: 1/3).isActive = true
        
        
        inputsContainerView.addSubview(nameSeparatorView)
          // x (leading trailing) , y top , width(leading trailing), height 2 or 3
        nameSeparatorView.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor).isActive = true
        nameSeparatorView.trailingAnchor.constraint(equalTo: inputsContainerView.trailingAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        
        inputsContainerView.addSubview(emailTextField)
         // x , y, width , height
        emailTextField.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor, constant: 10).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: inputsContainerView.trailingAnchor, constant: -10).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameSeparatorView.bottomAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor).isActive = true
        
        
        
        
        inputsContainerView.addSubview(emailSeparatorView)
          // x (leading trailing) , y top , width(leading trailing), height 2 or 3
        emailSeparatorView.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor).isActive = true
        emailSeparatorView.trailingAnchor.constraint(equalTo: inputsContainerView.trailingAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        inputsContainerView.addSubview(passwordTextField)
         // x , y, width , height
        passwordTextField.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor, constant: 10).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: inputsContainerView.trailingAnchor, constant: -10).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailSeparatorView.bottomAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor).isActive = true
        
    }
    func setupLoginRegisterButton(){
        // x , y, width , height
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor , constant: 8).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupProfileImageView (){
        // x , y, width , height
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        NSLayoutConstraint(item: profileImageView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 0.45, constant: 0).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}





extension UIColor {
    
    convenience init(r: CGFloat , g: CGFloat , b: CGFloat){
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
    }
    
    convenience init(hexRGB : Int ){
        let R = CGFloat((hexRGB >> 16) & 0xFF)
        let G = CGFloat((hexRGB >> 8) & 0xFF)
        let B = CGFloat(hexRGB & 0xFF)
        self.init(r: R, g: G, b: B)
    }
    
}
