//
//  WBTitleButton.swift
//  WeiboSwift
//
//  Created by mac on 17/2/6.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

class WBTitleButton: UIButton {

    init(title: String?) {
        super.init(frame: CGRect())
        
        if title == nil {
            setTitle("首页", for: [])
        }else {
            setTitle(title! + " ", for: [])
            
            setImage(UIImage(named: "navigationbar_arrow_down"), for: [])
            setImage(UIImage(named: "navigationbar_arrow_up"), for: .selected)
        }
        
        titleLabel?.font = UIFont.systemFont(ofSize: 17)
        setTitleColor(UIColor.darkGray, for: .normal)
        setTitleColor(UIColor.black, for: .highlighted)
        
        sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let titleLabel = titleLabel, let imageView = imageView else {
            return
        }
        
        // 将 label 的 x 向左移动 imageView 的宽度
//        titleLabel.frame = titleLabel.frame.offsetBy(dx: -imageView.bounds.width, dy: 0)
//        imageView.frame = imageView.frame.offsetBy(dx: titleLabel.bounds.width + 20, dy: 0)
        
        titleLabel.frame.origin.x = 0
        imageView.frame.origin.x = bounds.width - imageView.bounds.width
    }
}