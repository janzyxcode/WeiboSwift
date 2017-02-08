//
//  UIImageView+WebImage.swift
//  WeiboSwift
//
//  Created by mac on 17/2/7.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import Foundation
import SDWebImage

extension UIImageView {
    
    func ll_setImage(urlString: String?, placeholderImage: UIImage?, isAvatar: Bool = false) {
        
        guard let urlString = urlString,
            let url = URL(string: urlString)
        else {
            image = placeholderImage
            return
        }
        
        sd_setImage(with: url, placeholderImage: placeholderImage, options: [], progress: nil) { (image, _, _, _) in
            if isAvatar {
                self.image = image?.ll_avatarImage(size: self.bounds.size, lineWidth: 0.5)
            }
        }
    }
    
}

