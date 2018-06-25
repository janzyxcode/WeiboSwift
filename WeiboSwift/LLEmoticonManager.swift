//
//  LLEmoticonManager.swift
//  WeiboSwift
//
//  Created by mac on 17/2/15.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

class LLEmoticonManager {

    static let shared = LLEmoticonManager()
    lazy var packages = [LLEmoticonPackage]()
    
    lazy var bundle: Bundle = {
        let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil)
        return Bundle(path: path!)!
    }()

    private init() {
        loadPackages()
    }
    

    func recentEmoticon(em: LLEmoticon) {
        
        //        em.times.value += 1
        //
        //        if !packages[0].emoticons.contains(em){
        //            packages[0].emoticons.append(em)
        //        }
        //
        //        packages[0].emoticons.sort { (em1, em2) -> Bool in
        //            return em1.times > em2.times
        //        }
        //
        //        if packages[0].emoticons.count > 20 {
        //            packages[0].emoticons.removeSubrange(20..<packages[0].emoticons.count)
        //        }
    }
}


private extension LLEmoticonManager {
    
    func loadPackages() {
        guard let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
            let bundle = Bundle(path: path),
            let plistPath = bundle.path(forResource: "emoticons.plist", ofType: nil),
            let array = NSArray(contentsOfFile: plistPath)
            ,let models = DecodeJsoner.decodeJsonToModel(dict: array, [LLEmoticonPackage].self)
            else {
                return
        }
        packages += models

        for item in packages {
            guard let plistPath = bundle.path(forResource: "info.plist", ofType: nil, inDirectory: item.emoticon_group_path),
                let dict = NSDictionary(contentsOfFile: plistPath),
                let array = dict["emoticon_group_emoticons"],
                let models = DecodeJsoner.decodeJsonToModel(dict: array, [LLEmoticon].self)
                else {
                    continue
            }

            for m in models {
                m.directory = item.emoticon_group_path
            }

            item.emoticons += models
        }
    }
}

extension LLEmoticonManager {
    
    func findEmoticon(string: String) -> LLEmoticon? {
        for p in packages {
            let result = p.emoticons.filter(){ $0.chs == string }
            if result.count == 1 {
                return result[0]
            }
        }
        //        printLog(string)
        return nil
    }
}


extension LLEmoticonManager {
    func replaceEmoticon(_ attrString: NSMutableAttributedString, _ content: String, _ font: UIFont) {
        let pattern = "\\[.*?\\]"

        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
            return
        }

        let matches = regx.matches(in: content, options: [], range: NSRange(location: 0, length: attrString.length))

        // 倒序遍历
        for m in matches.reversed() {
            let r = m.range(at: 0)
            let subStr = (attrString.string as NSString).substring(with: r)
            if let em = LLEmoticonManager.shared.findEmoticon(string: subStr) {
                let imgText =  em.imageText(font: font)
                attrString.replaceCharacters(in: r, with: imgText)
            }
        }
    }
}
