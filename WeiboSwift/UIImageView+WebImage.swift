//
//  UIImageView+WebImage.swift
//  WeiboSwift
//
//  Created by mac on 17/2/7.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import Foundation
import SDWebImage
import Kingfisher

extension UIImageView {

    func setImage(urlString: String?, placeholderImage: UIImage?, isAvatar: Bool = false) {
        guard let urlString = urlString,
            let url = URL(string: urlString)
            else {
                image = placeholderImage
                return
        }

        kf.setImage(with: url, placeholder: placeholderImage, options: [], progressBlock: nil, completionHandler: nil)
    }
    
}

