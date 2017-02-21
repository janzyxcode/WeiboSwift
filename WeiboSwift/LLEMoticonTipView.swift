//
//  LLEMoticonTipView.swift
//  WeiboSwift
//
//  Created by liaonaigang on 2017/2/19.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit
import pop

class LLEMoticonTipView: UIImageView {

    private lazy var tipButton = UIButton()
    
    
    private var preEmoticon: LLEmoticon?
    
    var emoticon: LLEmoticon? {
        didSet {
            
            if emoticon == preEmoticon {
                return
            }
            
            preEmoticon = emoticon
            
            tipButton.setTitle(emoticon?.emoji, for: [])
            tipButton.setImage(emoticon?.image, for: [])
            
            let anim: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            anim.fromValue = 30
            anim.toValue = 8
            anim.springBounciness = 20
            anim.springSpeed = 20
            tipButton.layer.pop_add(anim, forKey: nil)
            
        }
    }
    
    
    init() {
        
        let bundle = LLEmoticonManager.shared.bundle
        let image = UIImage(named: "emoticon_keyboard_magnifier", in: bundle, compatibleWith: nil)
        
        
        super.init(image: image)
        
        isHidden = true
        
        // 设置锚点
        layer.anchorPoint = CGPoint(x: 0.5, y: 1.2)
        
        
        tipButton.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        tipButton.frame = CGRect(x: 0, y: 8, width: 36, height: 36)
        tipButton.center.x = bounds.width * 0.5
        tipButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        addSubview(tipButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
