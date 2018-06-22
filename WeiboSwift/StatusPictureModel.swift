//
//  StatusPictureModel.swift
//  WeiboSwift
//
//  Created by  user on 2018/5/31.
//  Copyright © 2018年 nailiao. All rights reserved.
//

import UIKit

class StatusPictureModel: NSObject, Codable {
    var thumbnail_pic: String?

    var thumbnailWap369Pic: String? {
        return thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/wap360/")
    }
}
