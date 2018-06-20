//
//  Int+Extensions.swift
//  UploadTool
//
//  Created by  user on 2018/4/11.
//  Copyright © 2018年 NG. All rights reserved.
//

import UIKit

extension Int {
    var boolValue: Bool {
        return self > 0 ? true : false
    }

    var cgFloatValue: CGFloat {
        return CGFloat(self)
    }
}
