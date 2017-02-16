//
//  LLEmoticonManager.swift
//  WeiboSwift
//
//  Created by mac on 17/2/15.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import Foundation

class LLEmoticonManager {
    
    // 为了便于表情的复用，建立一个单例，只加载一次表情数据
    static let shared = LLEmoticonManager()
    
    lazy var packages = [LLEmoticonPackage]()
    
    // 构造函数，如果在 init 之前增加 private 修饰符，可以要求调用者必须通过 shared 访问对象
    // OC 要重写 allocWithZone 方法
    private init() {
        loadPackages()
    }
    
}


private extension LLEmoticonManager {
    
    func loadPackages() {
        
        guard let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
              let bundle = Bundle(path: path),
              let plistPath = bundle.path(forResource: "emoticons.plist", ofType: nil),
              let array = NSArray(contentsOfFile: plistPath),
              let models = NSArray.yy_modelArray(with: LLEmoticonPackage.self, json: array) as? [LLEmoticonPackage]
        else {
            return
        }
        
        
        packages += models
        
    }
}

extension LLEmoticonManager {
    
    func findEmoticon(string: String) -> LLEmoticon? {
        
        for p in packages {
            
            // 在表情数组中过滤 string
            // 方法1
//            let result = p.emoticons.filter({ (em) -> Bool in
//                return em.chs == string
//            })
            
            // 方法2 尾随闭包
//            let result = p.emoticons.filter(){ (em) -> Bool in
//                return em.chs == string
//            }
            
            // 方法3 － 如果闭包中只有一句，并且是返回，闭包格式定义可以省略，参数省略后，使用 $0, $1... 依次替代原有的参数
//            let result = p.emoticons.filter(){
//                return $0.chs == string
//            }
            
            // 方法4 － 如果闭包中只有一句，并且是返回，闭包格式定义可以省略，参数省略后，使用 $0, $1... 依次替代原有的参数，return 也可以省略
            let result = p.emoticons.filter(){ $0.chs == string }
            
            // 判断结果数组的数量
            if result.count == 1 {
                return result[0]
            }
        }
        
        
        return nil
    }
}


extension LLEmoticonManager {
    
    func emoticonString(string: String, font: UIFont) -> NSAttributedString {
        
        
        let attrString = NSMutableAttributedString(string: string)
        
        // 建立正则表达式，过滤所有的表情文字
        // [] () 都是正则表达式的关键字，如果要参与匹配，需要转义
        let pattern = "\\[.*?\\]"
        
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
            return attrString
        }
        
        let matches = regx.matches(in: string, options: [], range: NSRange(location: 0, length: attrString.length))
        
        // 倒序遍历
        for m in matches.reversed() {
            
            let r = m.rangeAt(0)
            
            let subStr = (attrString.string as NSString).substring(with: r)
            
            if let em = LLEmoticonManager.shared.findEmoticon(string: subStr) {
                
                attrString.replaceCharacters(in: r, with: em.imageText(font: font))
            }
            
        }
        
        attrString.addAttributes([NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.darkGray], range: NSRange(location: 0, length: attrString.length))
        
        return attrString
    }

}
