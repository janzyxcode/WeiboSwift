//
//  UserAccount.swift
//  WeiboSwift
//
//  Created by liaonaigang on 2017/2/5.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit


class UserAccount: NSObject, Codable {
    //
    var access_token: String?
    var uid: String?
    var expires_in: Int?
    var remind_in: String?

    //
    var screen_name: String?
    var avatar_large: String?

    //
    var expiresDate: Date?


    static func filePath()-> String? {
        let libarayPaths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        guard let libarayPath = libarayPaths.first
            else {
                return nil
        }
        let filePath =  libarayPath + accountFile
        return filePath
    }

    func countExpiresDate() {
        guard let expiresIn = expires_in,
            let filePath = UserAccount.filePath() else {
                return
        }
        expiresDate = Date(timeIntervalSinceNow: TimeInterval(expiresIn))
        if expiresDate?.compare(Date()) != .orderedDescending {
            printLog("time out")
            access_token = nil
            uid = nil
            try? FileManager.default.removeItem(atPath: filePath)
        }
    }
}
