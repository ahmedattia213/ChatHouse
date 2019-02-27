//
//  LoginController.swift
//  ChatHouse
//
//  Created by Ahmed Amr on 1/16/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginController: UIViewController, ImagePickerDelegate {

    var messagesController: MessagesController?
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var imagePicker: ImagePicker!

    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()

    let loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(hexRGB: 0x4376CF)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleRegisterLoginButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()

    let nameTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter your name"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()

    let emailTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter your email"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()

    let passwordTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter your password"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.isSecureTextEntry = true
        return textfield
    }()

    let nameSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexRGB: 0xDCDCDC)
        return view
    }()

    let emailSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexRGB: 0xDCDCDC)
        return view
    }()

    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "userProfile")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageClick)))
        return imageView
    }()

    let loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Register", "Login"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.backgroundColor =  UIColor(hexRGB: 0x4376CF)
        sc.tintColor = .white
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged   )
        return sc

    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexRGB: 0x4390bc)
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.hideKeyboardWhenTappedAround()
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)

        setupInputsContainer()
        setupLoginRegisterButton()
        setupProfileImageView()
        setupLoginRegisterSegmentedControl()
    }

    func didSelect(selectedMedia: Any?) {
        self.profileImageView.image = selectedMedia as? UIImage
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func loginView() {
        nameTextField.removeFromSuperview()
        nameSeparatorView.removeFromSuperview()
    }
    func registerView() {
        setupInputsContainer()
    }
    func setupInputsContainer() {
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true

        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true

        inputsContainerView.addSubview(nameTextField)
        nameTextField.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor, constant: 10).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: inputsContainerView.trailingAnchor, constant: -10).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextFieldHeightAnchor =  nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true

        inputsContainerView.addSubview(nameSeparatorView)
        nameSeparatorView.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor).isActive = true
        nameSeparatorView.trailingAnchor.constraint(equalTo: inputsContainerView.trailingAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        inputsContainerView.addSubview(emailTextField)
        emailTextField.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor, constant: 10).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: inputsContainerView.trailingAnchor, constant: -10).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameSeparatorView.bottomAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true

        inputsContainerView.addSubview(emailSeparatorView)
        emailSeparatorView.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor).isActive = true
        emailSeparatorView.trailingAnchor.constraint(equalTo: inputsContainerView.trailingAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        inputsContainerView.addSubview(passwordTextField)
        passwordTextField.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor, constant: 10).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: inputsContainerView.trailingAnchor, constant: -10).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailSeparatorView.bottomAnchor).isActive = true
        passwordTextField.bottomAnchor.constraint(equalTo: inputsContainerView.bottomAnchor).isActive = true
    }

    func setupLoginRegisterButton() {
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 8).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    func setupProfileImageView () {
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -17).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.22).isActive = true
    }

    func setupLoginRegisterSegmentedControl() {
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -7).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

}
