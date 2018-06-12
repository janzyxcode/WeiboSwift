//
//  Common.swift
//  WeiboSwift
//
//  Created by  user on 2018/6/12.
//  Copyright © 2018年 nailiao. All rights reserved.
//

import Foundation


/// rgba
func rgba(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpa: CGFloat = 1) -> UIColor {
    return UIColor.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpa)
}
