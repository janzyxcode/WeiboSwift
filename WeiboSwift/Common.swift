//
//  Common.swift
//  WeiboSwift
//
//  Created by  user on 2018/6/12.
//  Copyright © 2018年 nailiao. All rights reserved.
//

import UIKit

let WBAppKey = "3257517883"
let WBAppSecret = "e7e52263cae20e6cb8d353a767e1c557"
let WBRedirectURI = "http://www.baidu.com"


// 全局通知定义
let WBUserShouldLoginNotification = "WBUserShouldLoginNotification"
let WBUserLoginSuccessedNotification = "WBUserLoginSuccessedNotification"


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

/// rgba
func rgba(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpa: CGFloat = 1) -> UIColor {
    return UIColor.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpa)
}
