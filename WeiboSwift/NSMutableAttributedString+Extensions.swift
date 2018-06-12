//
//  NSMutableAttributedString+Extensions.swift
//  WeiboSwift
//
//  Created by  user on 2018/6/12.
//  Copyright © 2018年 nailiao. All rights reserved.
//

import Foundation

extension NSMutableAttributedString {
    static func singleLineSize(fontSize: CGFloat, _ text: String? = nil) -> CGSize {
        var str = text ?? "哈"
        let size = (str as NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize)])
        return size
    }
}
