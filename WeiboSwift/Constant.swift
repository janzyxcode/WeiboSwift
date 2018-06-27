//
//  Constant.swift
//  WeiboSwift
//
//  Created by  user on 2018/6/12.
//  Copyright © 2018年 nailiao. All rights reserved.
//

import UIKit


let mainScreenBounds = UIScreen.main.bounds
/// 屏幕宽度
let screenWidth = mainScreenBounds.size.width
/// 屏幕高度
let screenHeight = mainScreenBounds.size.height


/// 状态栏高度
var statusBarHeight: CGFloat {
    return isIphoneX ? 44 : 20
}

/// 导航栏高度
var navigationBarHeight: CGFloat = 44

/// 状态栏和导航栏的高度
var statusNaviBarHeight: CGFloat {
    return statusBarHeight + navigationBarHeight
}

/// 标签栏高度
var tabBarHeight: CGFloat {
    return isIphoneX ? 83 : 49
}

/// 是否是iPhoneX
var isIphoneX: Bool {
    return screenHeight == 812
}

