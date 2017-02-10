//
//  WBComposeTypeView.swift
//  WeiboSwift
//
//  Created by mac on 17/2/10.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

class WBComposeTypeView: UIView {

    class func composeTypeView() -> WBComposeTypeView {
        let nib = UINib(nibName: "WBComposeView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WBComposeTypeView
        
        // XIB 默认 600*600
        v.frame = UIScreen.main.bounds
        
        return v
    }

    
    func show() {
        
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        vc.view.addSubview(self)
    }
    
    
    override func awakeFromNib() {
        setupUI()
    }
    
    func clickButton() {
        print("click")
    }
}

private extension WBComposeTypeView {
    func setupUI() {
        
        let btn = WBComposeTypebutton.composeTypeButton(imageName: "tabbar_compose_delete", title: "试一试")
        btn.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        addSubview(btn)
        btn.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
    }
}
