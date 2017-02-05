//
//  WBUserAccount.swift
//  WeiboSwift
//
//  Created by liaonaigang on 2017/2/5.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

class WBUserAccount: NSObject {
    
    var access_token: String?
    var uid: String?
    var expires_in: TimeInterval = 0 {
        didSet {
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    
    var expiresDate: Date?
    
    override var description: String {
        return yy_modelDescription()
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
        
        let filePath =  libarayPath + "useraccount.json"

        (data as NSData).write(toFile: filePath, atomically: true)
        
    }
}
