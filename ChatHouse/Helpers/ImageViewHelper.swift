//
//  URLHelper.swift
//  ChatHouse
//
//  Created by Ahmed Amr on 2/8/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit
let imageCache = NSCache< NSString , UIImage>()

extension UIImageView {

    func retrieveDataFromUrl(urlString: String) {
        self.image = nil
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }

        let url = URL(string: urlString)
            URLSession.shared.dataTask(with: url!) { (data, _, error) in
                if error != nil {
                    print(error!)
                    return
                }

                DispatchQueue.main.async {
                    if let downloadedImage = UIImage(data: data!) {
                        self.image = downloadedImage
                        imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    }
                }
                }.resume()
    }
}
