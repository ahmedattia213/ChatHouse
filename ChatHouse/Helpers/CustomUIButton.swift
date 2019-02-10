//
//  UIhelper.swift
//  ChatHouse
//
//  Created by Ahmed Amr on 1/23/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit

class UIButtonRoundTopRightBottomRight: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
}

class UIButtonRoundTopLeftBottomLeft: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
}
