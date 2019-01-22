//
//  LoginController.swift
//  ChatHouse
//
//  Created by Ahmed Amr on 1/16/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
class LoginController: UIViewController {
    
    var stackView : UIStackView!
    
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
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
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
    
    let chooseLogin : UIButtonRoundTopRightBottomRight = {
        //title, background color , target
        let button = UIButtonRoundTopRightBottomRight(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hexRGB: 0x4376CF)
        button.addTarget(self, action: #selector(handleChooseLogin), for: .touchUpInside)
        return button
    }()
    
    let chooseRegister : UIButtonRoundTopLeftBottomLeft = {
        let button = UIButtonRoundTopLeftBottomLeft(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(UIColor(hexRGB: 0x4376CF), for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleChooseRegister), for: .touchUpInside)
        return button
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexRGB: 0x4390bc)
     
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
       
        setupInputsContainer()
        setupLoginRegisterButton()
        setupChooseLoginRegister()
        setupProfileImageView()
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

extension UIButton {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
