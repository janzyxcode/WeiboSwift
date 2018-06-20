//
//  SingletonData.swift
//  WeiboSwift
//
//  Created by  user on 2018/5/30.
//  Copyright © 2018年 nailiao. All rights reserved.
//

import UIKit
import Alamofire

class SingletonData: NSObject {

    static let shared = SingletonData()
    private override init() {
    }

    var userAccount: UserAccount?
    lazy var formatter = DateFormatter()
    lazy var calendar = Calendar(identifier: Calendar.Identifier.gregorian)

    var userLogon: Bool {
        return userAccount?.access_token != nil
    }

    func saveUserAccount() {
        guard let filePath = UserAccount.filePath(),
            let account = userAccount
            else {
                return
        }
        DecodeJsoner.encodeModelToString(account)
        DecodeJsoner.saveModel(toFile: filePath, value: account)
    }

    func getLocalUserAccount() {
        guard let filePath = UserAccount.filePath(),
            let data = FileManager.default.contents(atPath: filePath) else {
            return
        }

        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            if let dic = json as? [String: Any] {
                userAccount = DecodeJsoner.decodeJsonToModel(dict: dic, UserAccount.self)
                userAccount?.countExpiresDate()
            }
        } catch {
            printLog(error)
        }
    }
}
