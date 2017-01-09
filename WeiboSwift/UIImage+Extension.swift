//
//  UIImage+Extension.swift
//  WeiboSwift
//
//  Created by mac on 17/1/9.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

extension UIImage {
    
    func selectedImage(imageName: String) -> UIImage? {
        let image = UIImage(named: imageName + "_selected")
        return image
    }
    
    func highlightedImage(imageName: String) -> UIImage? {
        let image = UIImage(named: imageName + "_highlighted")
        return image
    }
}
