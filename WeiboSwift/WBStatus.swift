//
//  WBStatus.swift
//  WeiboSwift
//
//  Created by mac on 17/1/17.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit
import YYModel

class WBStatus: NSObject {

    // Int 类型，在64位的机器是64位，在32位机器就是32位
    // 如果不写 Int64 在 iPad 2/iPhone 5/5c／4s／4 都无法正常运行
    var id: Int64 = 0
    
    var text: String?
    
    // 重写 description的计算型属性
    override var description: String {
        return yy_modelDescription()
    }
    
}
