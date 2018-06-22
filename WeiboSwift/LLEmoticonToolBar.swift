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
        
//        let manager = LLEmoticonManager.shared
//        
//        for (i, p) in manager.packages.enumerated() {
//            
//            let btn = UIButton()
//            btn.setTitle(p.emoticon_group_name, for: [])
//            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//            btn.setTitleColor(UIColor.white, for: [])
//            btn.setTitleColor(UIColor.darkGray, for: .highlighted)
//            btn.setTitleColor(UIColor.darkGray, for: .selected)
//            btn.sizeToFit()
//            btn.tag = i
//            btn.addTarget(self, action: #selector(clickItem), for: .touchUpInside)
//            addSubview(btn)
//            
//            
//            let imageName = "compose_emotion_table_\(p.bgImageName ?? "")_normal"
//            let imageNameHL = "compose_emotion_table_\(p.bgImageName ?? "")_selected"
//            
//            var image = UIImage(named: imageName, in: manager.bundle, compatibleWith: nil)
//            var imageHL = UIImage(named: imageNameHL, in: manager.bundle, compatibleWith: nil)
//            
//            let size = image?.size ?? CGSize()
//            let inset = UIEdgeInsets(top: size.height * 0.5, left: size.width * 0.5, bottom: size.height * 0.5, right: size.width * 0.5)
//            
//            image = image?.resizableImage(withCapInsets: inset)
//            imageHL = imageHL?.resizableImage(withCapInsets: inset)
//            
//            btn.setBackgroundImage(image, for: [])
//            btn.setBackgroundImage(imageHL, for: .highlighted)
//            btn.setBackgroundImage(imageHL, for: .selected)
//            
//            btn.sizeToFit()
//        }
//        
//        (subviews[0] as! UIButton).isSelected = true
    }
    
}
