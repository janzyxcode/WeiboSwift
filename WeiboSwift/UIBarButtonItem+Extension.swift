//
//  UIBarButtonItem+Extension.swift
//  WeiboSwift
//
//  Created by mac on 17/1/10.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    
    /// 创建 UIBarButtonItem
    ///
    /// - Parameters:
    ///   - title: title
    ///   - fontSize: fontSize，默认16号
    ///   - target: target
    ///   - action: action
    convenience init(title: String, fontSize: CGFloat = 16, target: AnyObject? ,action: Selector, isBack: Bool = false) {
        
        let btn = UIButton(type: .custom)
        btn .setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        btn.setTitleColor(UIColor.orange, for: .highlighted)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn .addTarget(target, action: action, for: .touchUpInside)
        
        if isBack {
            
            btn.setImage(UIImage(named: "hotweibo_back_icon"), for: .normal)
            btn.setImage(UIImage(named: "hotweibo_back_icon" + "_highlighted"), for: .highlighted)
        }
        
        btn.sizeToFit()
        
        self.init(customView: btn)
    }
    
    
    class func fixtedSpace(title: String, fontSize: CGFloat = 16, target: AnyObject? ,action: Selector, isBack: Bool = false) -> [UIBarButtonItem] {
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -8
        return [negativeSpacer,UIBarButtonItem(title: title, fontSize: fontSize, target: target, action: action, isBack: isBack)]
    }
    
}
