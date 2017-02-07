//
//  WBStatusPictureView.swift
//  WeiboSwift
//
//  Created by mac on 17/2/7.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

class WBStatusPictureView: UIView {
    
    var urls: [WBStatusPicture]? {
        didSet {
            for v in subviews {
                v.isHidden = true
            }

            var index = 0
            for url in urls ?? [] {
                
                let iv = subviews[index] as! UIImageView
                
                if index == 1 && urls?.count == 4 {
                    index += 1
                }
                iv.ll_setImage(urlString: url.thumbnail_pic, placeholderImage: nil)
                iv.isHidden = false
                index += 1
            }
            
        }
    }
    
    
    @IBOutlet weak var heightCons: NSLayoutConstraint!
    
    override func awakeFromNib() {
        setupUI()
    }
    
}


extension WBStatusPictureView {
    
    func setupUI() {
        
        backgroundColor = superview?.backgroundColor
        clipsToBounds = true
        
        let count = 3
        let rect = CGRect(x: 0, y: WBStatusPictureViewOutterMargin, width: WBStatusPictureItemWidth, height: WBStatusPictureItemWidth)
        
        for i in 0..<count * count {
            
            let row = CGFloat(i / count)
            let col = CGFloat(i % count)
            let xOffset = col * (WBStatusPictureItemWidth + WBStatusPictureViewInnerMargin)
            let yOffset = row * (WBStatusPictureItemWidth + WBStatusPictureViewInnerMargin)
            
            let iv = UIImageView()
            iv.frame = rect.offsetBy(dx: xOffset, dy: yOffset)
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            addSubview(iv)
        }
        
    }
    
}
