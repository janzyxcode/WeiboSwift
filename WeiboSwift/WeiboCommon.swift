//
//  WeiboCommon.swift
//  WeiboSwift
//
//  Created by mac on 17/1/18.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import Foundation


let WBAppKey = "3257517883"
let WBAppSecret = "e7e52263cae20e6cb8d353a767e1c557"
let WBRedirectURI = "http://www.baidu.com"


// 全局通知定义
let WBUserShouldLoginNotification = "WBUserShouldLoginNotification"
let WBUserLoginSuccessedNotification = "WBUserLoginSuccessedNotification"


let WBStatusPictureViewOutterMargin = CGFloat(12)
let WBStatusPictureViewInnerMargin = CGFloat(3)
let WBStatusPictureViewWidth = UIScreen.main.bounds.width - 2 * WBStatusPictureViewOutterMargin
let WBStatusPictureItemWidth = (WBStatusPictureViewWidth - 2 * WBStatusPictureViewInnerMargin) / 3


let accountFile = "/userAccount.data"


/// 自定义Log打印 -（T表示不指定日志信息参数类型）
///
/// - Parameters:
///   - message: 打印信息
///   - file: 打印文件
///   - method: 打印所在文件中的方法
///   - line: 打印所在文件的行
func printLog<T>(_ message: T,
              file: String = #file,
              method: String = #function,
              line: Int = #line) {
    
    #if DEBUG
        let classStr = (file as NSString).lastPathComponent as NSString
        let classSimpleStr = classStr.substring(to: classStr.length - 6)
        print("\(Date(timeIntervalSinceNow: 8 * 3600)) \(Bundle.main.namespace)[\(classSimpleStr).\(method).m:\(line)] \(message)")
    #endif
}
