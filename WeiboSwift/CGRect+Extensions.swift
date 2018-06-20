//
//  CGRect+Extensions.swift
//  WeiboSwift
//
//  Created by  user on 2018/6/12.
//  Copyright © 2018年 nailiao. All rights reserved.
//

import UIKit

extension CGRect {

    var x: CGFloat {
        return origin.x
    }

    var y: CGFloat {
        return origin.y
    }

    var trailing: CGFloat {
        return origin.x + size.width
    }

    var bottom: CGFloat {
        return origin.y + size.height
    }

    static func originFromRect(_ size: CGSize) -> CGRect {
        return CGRect(x: 0, y: 0, width: size.width, height: size.height)
    }
}
