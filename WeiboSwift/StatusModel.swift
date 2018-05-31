//
//  StatusModel.swift
//  WeiboSwift
//
//  Created by  user on 2018/5/31.
//  Copyright © 2018年 nailiao. All rights reserved.
//

import UIKit

class StatusModel: NSObject, Codable {

    var user: UserModel?
    //  被转发的原创微博
    var retweeted_status: StatusModel?
    var pic_urls: [StatusPictureModel]?

    // Int 类型，在64位的机器是64位，在32位机器就是32位
    // 如果不写 Int64 在 iPad 2/iPhone 5/5c／4s／4 都无法正常运行
    var id: Int64 = 0
    var text: String?
    var created_at: String?
    var createdDate: Date?
    var source: String?
    var resosts_count: Int?
    var comments_count: Int?
    var attitudes_count: Int?

//    var created_at: String? {
//        didSet {
//            createdDate = Date.ll_sinaDate(string: created_at ?? "")
//        }
//    }
//
//    var source: String? {
//        didSet {
//            // 重新计算来源并且保存
//            // 在 didSet 中，给source 再次设置值，不会调用 didSet
//            source = "来自" + (source?.ll_href()?.text ?? "")
//        }
//    }
}
