//
//  LLEmoticonToolBar.swift
//  KeyboardInput
//
//  Created by mac on 17/2/17.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

@objc protocol LLEmoticonToolBarDelegae: NSObjectProtocol {
    func emoticonToolBarDidSelectedItemIndex(toolbar:  LLEmoticonToolBar, index: Int)
}


class LLEmoticonToolBar: UIView {

    var selectIndex: Int = 0 {
        didSet {
            
            for btn in subviews as! [UIButton] {
                btn.isSelected = false
            }
            
            (subviews[selectIndex] as! UIButton).isSelected = true
            
        }
    }
    
    weak var delegate: LLEmoticonToolBarDelegae?
    
    override func awakeFromNib() {
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let count = subviews.count
        let w = bounds.width / CGFloat(count)
        let rect = CGRect(x: 0, y: 0, width: w, height: bounds.height)
        
        for (i, btn) in subviews.enumerated() {
            btn.frame = rect.offsetBy(dx: CGFloat(i) * w, dy: 0)
        }
    }
    
    
    @objc func clickItem(button: UIButton) {
        delegate?.emoticonToolBarDidSelectedItemIndex(toolbar:self, index: button.tag)

    }
}

private extension LLEmoticonToolBar {
    
    func setupUI() {
        
        let manager = LLEmoticonManager.shared
        
        for (i, p) in manager.packages.enumerated() {
            
            let btn = UIButton()
            btn.setTitle(p.groupName, for: [])
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btn.setTitleColor(UIColor.white, for: [])
            btn.setTitleColor(UIColor.darkGray, for: .highlighted)
            btn.setTitleColor(UIColor.darkGray, for: .selected)
            btn.sizeToFit()
            btn.tag = i
            btn.addTarget(self, action: #selector(clickItem), for: .touchUpInside)
            addSubview(btn)
        }
        
        (subviews[0] as! UIButton).isSelected = true
    }
    
}
