//
//  StatusModel.swift
//  WeiboSwift
//
//  Created by  user on 2018/5/31.
//  Copyright © 2018年 nailiao. All rights reserved.
//

import UIKit

class StatusModel: NSObject, Codable {

    // Int 类型，在64位的机器是64位，在32位机器就是32位
    // 如果不写 Int64 在 iPad 2/iPhone 5/5c／4s／4 都无法正常运行
    var created_at: String?
    var id: Int64 = 0
    var idstr: String?
    var text: String?
    var source: String?
    var favorited = false
    var truncated = false
    var thumbnail_pic: String?
    var bmiddle_pic: String?
    var original_pic: String?
    var resosts_count: Int?
    var comments_count: Int?
    var attitudes_count: Int?

    var user: UserModel?
    var retweeted_status: StatusModel?
    var pic_urls: [StatusPictureModel]?

}
