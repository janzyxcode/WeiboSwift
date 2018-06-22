//
//  LLEmoticon.swift
//  WeiboSwift
//
//  Created by mac on 17/2/15.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

class LLEmoticon: NSObject, Codable {

    // true: emoji     fasle: 表情图片
    var type: String?
    var chs: String?
    var png: String?
    var emoji: String?
    var gif: String?
    var cht: String?
    
    //FIXME:
//    var times: Int = 0

    // 表情模型所在的目录
    var directory: String?
    
    
    // unicode 的编码，展现使用 UTF8 1～4 个字节表示一个字符
    var code: String? {
        didSet {
            guard let code = code else {
                return
            }
            
            // 实例化字符扫描
            let scanner = Scanner(string: code)
            
            // 从 code 中扫描出 十六进制的数值
            var result: UInt32 = 0
            scanner.scanHexInt32(&result)

            // 使用  Uint32 的数值，生成一个 UTF8的字符
            emoji = String(Character(UnicodeScalar(result)!))
        }
    }
    
    // 图片表情对应的图像
    var image: UIImage? {
        if type == "1"{
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
        
        let attactment = LLEmotionAttachment()
        attactment.chs = chs
        
        attactment.image = image
        let height = font.lineHeight
        attactment.bounds = CGRect(x: 0, y: -4, width: height, height: height)
        
        return NSAttributedString(attachment: attactment)
    }
 
}
