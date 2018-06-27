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

    var bmiddle_pic: String? {
        return thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/bmiddle/")
    }

    var original_pic: String? {
        return thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/large/")
    }

    var isGif: Bool {
        if let url = thumbnail_pic {
            return (url as NSString).pathExtension.lowercased() == "gif"
        }
        return false
    }

    var gifToPngBmiddle_pic: String? {
        if isGif {
            return bmiddle_pic?.replacingOccurrences(of: ".gif", with: ".png")
        }
        return bmiddle_pic
    }

}
