//
//  LLEmoticon.swift
//  WeiboSwift
//
//  Created by mac on 17/2/15.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

class LLEmoticon: NSObject {

    // true: emoji     fasle: 表情图片
    var type = false
    var chs: String?
    var png: String?
    var code: String?
    
    // 表情模型所在的目录
    var directory: String?
    
    // 图片表情对应的图像
    var image: UIImage? {
        if type {
            return nil
        }
        
        guard let directory = directory,
            let png = png,
            let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
            let bundle = Bundle(path: path)
        else {
            return nil
        }
        
        return UIImage(named: "\(directory)/\(png)", in: bundle, compatibleWith: nil)
        
    }
    
    
    func imageText(font: UIFont)-> NSAttributedString {
        
        guard let image = image else {
            return NSAttributedString(string: "")
        }
        
        let attactment = NSTextAttachment()
        
        attactment.image = image
        let height = font.lineHeight
        attactment.bounds = CGRect(x: 0, y: -4, width: height, height: height)
        
        return NSAttributedString(attachment: attactment)
    }
    
    override var description: String {
        return yy_modelDescription()
    }
}
