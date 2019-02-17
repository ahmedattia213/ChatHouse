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
        self.hideKeyboard()
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)

        setupInputsContainer()
        setupLoginRegisterButton()
        setupProfileImageView()
        setupLoginRegisterSegmentedControl()
    }

    func didSelect(image: UIImage?) {
        self.profileImageView.image = image
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
