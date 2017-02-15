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
    
    override var description: String {
        return yy_modelDescription()
    }
}
