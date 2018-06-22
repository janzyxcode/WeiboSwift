//
//  LLEmoticonPackage.swift
//  WeiboSwift
//
//  Created by mac on 17/2/15.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

class LLEmoticonPackage: NSObject, Codable {

    var emoticon_group_name: String?
    var emoticon_group_path: String?

    lazy var emoticons = [LLEmoticon]()

    var numberOfPages: Int {
        return (emoticons.count - 1) / 20 + 1
    }

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
    
}
