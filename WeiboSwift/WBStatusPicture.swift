//
//  WBStatusPicture.swift
//  WeiboSwift
//
//  Created by mac on 17/2/7.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

class WBStatusPicture: NSObject {

    var thumbnail_pic: String? {
        didSet {
            thumbnail_pic = thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/wap360/")
        }
    }
    
    
    
    override var description: String {
        return yy_modelDescription()
    }
}
