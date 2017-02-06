//
//  WBUserAccount.swift
//  WeiboSwift
//
//  Created by liaonaigang on 2017/2/5.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

private let accountFile = "/useraccount.json"


class WBUserAccount: NSObject {
    
    var access_token: String?
    var uid: String?
    var expires_in: TimeInterval = 0 {
        didSet {
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    
    var expiresDate: Date?
    
    var screen_name: String?
    var avatar_large: String?
    
    override var description: String {
        return yy_modelDescription()
    }
    
    
    override init() {
        
        super.init()
        
        let libarayPaths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        
        guard let libarayPath = libarayPaths.first
            else {
                return
        }
        
        let filePath =  libarayPath + accountFile
        print(filePath)
        guard let data = NSData(contentsOfFile: filePath),
            let dict = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [String: AnyObject]
            else {
                return
        }
        
        // 用户是否登陆的关键代码
        //        self.yy_modelSet(with: dict ?? [:])
        yy_modelSet(with: dict ?? [:])
        
        // 测试过期日期
//        expiresDate = Date(timeIntervalSinceNow: -3600 * 24)
        print(expiresDate as Any)
        
        
        if expiresDate?.compare(Date()) != .orderedDescending {
            print("time out")
            
            access_token = nil
            uid = nil
            try? FileManager.default.removeItem(atPath: filePath)
        }
        
        print("normal－－\(self)")
    }
    
    
    /*
     1、偏好设置（小） - Xcode 8 beta 无效
     2、沙盒 - 归档／plist／‘json’
     3、数据库（FMDB／CoreData）
     4、钥匙串访问
     */
    func saveAccount() {
        
        var dict = (self.yy_modelToJSONObject() as? [String: AnyObject]) ?? [:]
        dict.removeValue(forKey: "expires_in")
        
        let libarayPaths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
            let libarayPath = libarayPaths.first
            else {
                return
        }
        
        let filePath =  libarayPath + accountFile
        
        (data as NSData).write(toFile: filePath, atomically: true)
        
    }
}
