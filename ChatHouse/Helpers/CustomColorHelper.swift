//
//  CustomColorHelper.swift
//  ChatHouse
//
//  Created by Ahmed Amr on 1/23/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
    }
    convenience init(hexRGB: Int ) {
      let (R, G, B) = (CGFloat((hexRGB >> 16) & 0xFF), CGFloat((hexRGB >> 8) & 0xFF), CGFloat(hexRGB & 0xFF))
        self.init(r: R, g: G, b: B)
    }

}

extension UIViewController {
    func hideKeyboard() {
         self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }

    @objc func dismissKeyboard() {
         self.view.endEditing(true)
    }
}
