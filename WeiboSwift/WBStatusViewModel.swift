//
//  WBStatusViewModel.swift
//  WeiboSwift
//
//  Created by mac on 17/2/7.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

class WBStatusViewModel: NSObject {
    
    // 微博模型
    var status: StatusModel

    var rowHeight: CGFloat = 0
    
    init(model: StatusModel) {
        self.status = model
    }

}

