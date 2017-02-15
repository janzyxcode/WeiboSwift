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
    
    var user: WBUser?
    
    var created_at: String?
    
    var source: String? {
        didSet {
            // 重新计算来源并且保存
            // 在 didSet 中，给source 再次设置值，不会调用 didSet
           source = "来自" + (source?.ll_href()?.text ?? "")
        }
    }
    
    //  被转发的原创微博
    var retweeted_status: WBStatus?
    
    var resosts_count:Int = 0
    var comments_count:Int = 0
    var attitudes_count:Int = 0
    
    var pic_urls: [WBStatusPicture]?
    
    // 重写 description的计算型属性
    override var description: String {
        return yy_modelDescription()
    }
    
    
    /// 类函数 -> 告诉第三方框架 YY_Model 如果遇到数组类型的属性，数组中存放的对象是什么类
    /// NSArray 中保存对象的类型通常是 'id' 类型
    /// OC 中的泛型是 Swift 推出后，苹果味了兼容给 OC 增加的
    /// 从允许时角度，仍然不知道数组中应该存放什么类型的对象
    
    /* 所有的第三方框架几乎都是如此 */
    class func modelContainerPropertyGenericClass() -> [String: AnyClass] {
        return ["pic_urls": WBStatusPicture.self]
    }
    
}
