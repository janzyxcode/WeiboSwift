//
//  WBWelcomeView.swift
//  WeiboSwift
//
//  Created by mac on 17/2/6.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit
import SDWebImage

class WBWelcomeView: UIView {

    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var tipL: UILabel!
    
    @IBOutlet weak var bottomCons: NSLayoutConstraint!
    
    
    class func welcomeView() -> WBWelcomeView {
        let nib = UINib(nibName: "WBWelcomeView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil).first as! WBWelcomeView
        
        // 从XIB加载的视图，默认尺寸为 600 x 600
        v.frame = UIScreen.main.bounds
        return v
    }
    
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        // initwithcode 只是刚刚从 XIB 的二进制文件将视图数据加载完成
//        // 还没有和代码连线建立起关系，所有开放时，千万不要在这个方法中处理 UI
//        print("iconview-\(iconView)")
//    }
    
    override func awakeFromNib() {
        
        if let title = WBNetworkManager.shared.userAccount.screen_name {
            tipL.text = title
        }
        
        guard let urlString = WBNetworkManager.shared.userAccount.avatar_large,
            let url = URL(string: urlString)
            
        else {
            return
        }

        iconView.sd_setImage(with: url, placeholderImage: UIImage(named: "avator_default"))
        iconView.layer.cornerRadius = iconView.bounds.width * 0.5
        iconView.layer.masksToBounds = true
        
    }

     /// 自动布局系统更新完成约束后，会自动调用此方法
     /// 通常是对子视图布局进行修改
//    override func layoutSubviews() {
//        
//    }
    
    /// 视图被添加到 window上，表示视图已经显示
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        // 视图是使用自动布局来设置的，只是设置了约束
        // layoutIfNeeded 会直接按照当前的约束直接更新空间位置
        // 执行之后，控件所在位置就是XIB 中布局的位置
        self.layoutIfNeeded()
        
        bottomCons.constant = bounds.size.height - 200
        
        // 如果控件们的 frame 还没有计算号，所有的约束会一起动画
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            
            self.tipL.alpha = 1
            // 更新约束
            self.layoutIfNeeded()
            
        }) { (_) in
             self.removeFromSuperview()
        }
    }
    
    
}
