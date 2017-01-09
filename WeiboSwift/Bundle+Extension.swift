//
//  Bundle+Extension.swift
//  DailySwift
//
//  Created by mac on 17/1/6.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import Foundation

extension Bundle {
    
    var namespace: String {
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
    
}
