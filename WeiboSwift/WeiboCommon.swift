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
