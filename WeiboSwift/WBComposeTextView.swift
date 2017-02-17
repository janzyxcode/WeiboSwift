//
//  WBComposeTextView.swift
//  WeiboSwift
//
//  Created by mac on 17/2/17.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

class WBComposeTextView: UITextView {

    lazy var placehoderLabel = UILabel()
    
    override func awakeFromNib() {
        setupUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func textChanged(n: Notification){
        placehoderLabel.isHidden = self.hasText
    }
}



private extension WBComposeTextView {
    
    func setupUI() {
        
        /**
         0、注册通知
           － 通知是一对多，如果其他控件监听到当前文本视图的通知，不会影响
           － 如果使用代理，其他控件就无法使用代理监听通知，最后设置的代理对象有效
         
         日常开发中，代理的监听方式是最多的
         
         － 代理发生事件时，直接让代理执行协议方法
            代理效率更高
            直接的方向传值
         
         － 通知是发生事件时，将通知发送给通知中心，通知中心再‘广播’通知
            通知效率相对低一些
            如果层次嵌套的非常深，可以使用通知传值
         */
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged(n:)), name: NSNotification.Name.UITextViewTextDidChange, object: self)
        
        
        placehoderLabel.text = "分享新鲜事..."
        placehoderLabel.textColor = UIColor.lightGray
        placehoderLabel.frame.origin = CGPoint(x: 5, y: 8)
        placehoderLabel.font = self.font
        placehoderLabel.sizeToFit()
        addSubview(placehoderLabel)
    }
}
