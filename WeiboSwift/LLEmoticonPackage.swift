//
//  LLEmoticonPackage.swift
//  WeiboSwift
//
//  Created by mac on 17/2/15.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit
import YYModel

class LLEmoticonPackage: NSObject {

    var groupName: String?
    var directory: String? {
        didSet {
            guard let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
                let bundle = Bundle(path: path),
                let plistPath = bundle.path(forResource: "info.plist", ofType: nil, inDirectory: directory),
                let array = NSArray(contentsOfFile: plistPath),
                let models = NSArray.yy_modelArray(with: LLEmoticon.self, json: array) as? [LLEmoticon]
                else {
                    return
            }
            
            for m in models {
                m.directory = directory
            }
            
            emoticons += models
        }
    }
    
    lazy var emoticons = [LLEmoticon]()
    
    // 表情页面数量
    var numberOfPages: Int {
        return (emoticons.count - 1) / 20 + 1
    }
    
    var bgImageName: String?
    
    // 从懒加载的表情包中，按照 page 截取最多 20 个表情模型的数组
    func emoticon(page: Int)-> [LLEmoticon] {
    
        let count = 20
        let location = page * count
        var length = count
        
        if location + length > emoticons.count {
            length = emoticons.count - location
        }
        
        let range = NSRange(location: location, length: length)
        
        let subArray = (emoticons as NSArray).subarray(with: range)
        
        return subArray as! [LLEmoticon]
    }
    
    
    override var description: String {
        return yy_modelDescription()
    }
}
