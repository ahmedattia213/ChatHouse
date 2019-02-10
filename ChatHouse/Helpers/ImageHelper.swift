//
//  ImageHelper.swift
//  ChatHouse
//
//  Created by Ahmed Amr on 2/7/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit

extension String {
    func getImageWithUrl() -> UIImage {
        let myURL = URL(string: self)
        if let data = try? Data(contentsOf: myURL!) {
            if let image = UIImage(data: data) {
                return image
            }
        }
        return UIImage(named: "userProfile")!
    }
}
