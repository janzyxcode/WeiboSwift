//
//  UIImageView+WebImage.swift
//  WeiboSwift
//
//  Created by mac on 17/2/7.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImageView {

    func setImage(urlString: String?, placeholderImage: UIImage?, _ isAvatar: Bool = false) {
        guard let urlString = urlString,
            let url = URL(string: urlString)
            else {
                image = placeholderImage
                return
        }

        kf.setImage(with: url, placeholder: placeholderImage, options: [], progressBlock: nil) { (downImage, _, _, _) in
            if isAvatar {
                if let downImage = downImage {
                    self.image = downImage.avatarImage(size: downImage.size)
                }
            }
        }
    }

    func waitAndGetImageSize(_ urlStr: String, completion: @escaping (_ size: CGSize)->Void) {
        var imgvsize = CGSize.zero
        let group = DispatchGroup()
        group.enter()

        kf.setImage(with: URL(string: urlStr), placeholder: nil, options: [], progressBlock: nil) { (downImage, _, _, _) in
            if let downImage = downImage {
                imgvsize = downImage.size
            }
            group.leave()
        }

        group.notify(queue: DispatchQueue.main) {
            completion(imgvsize)
        }
    }
}

