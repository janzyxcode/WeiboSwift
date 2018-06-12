//
//  UserModel.swift
//  WeiboSwift
//
//  Created by  user on 2018/5/31.
//  Copyright © 2018年 nailiao. All rights reserved.
//

import UIKit

class UserModel: NSObject, Codable {
    var id: Int64 = 0
    // 用户昵称
    var screen_name: String?
    // 用户头像  50*50
    var profile_image_url: String?
    // 认证类型，－1：没有认证， 0:认证用户， 2、3、5:企业认证，220：达人
    var verified_type: Int = 0
    // 会员等级 0-6
    var mbrank: Int = 0
}
