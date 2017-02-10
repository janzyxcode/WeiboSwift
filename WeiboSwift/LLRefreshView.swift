//
//  LLRefreshView.swift
//  WeiboSwift
//
//  Created by mac on 17/2/9.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

class LLRefreshView: UIView {

    /// 刷新状态
    /**
    iOS 系统中 UIView 封装的旋转动画
     － 默认顺时针旋转
     － 就近原则
     － 要想实现同方向旋转，需要调整一个 非常小的数字（近）
     － 如果想实现360度旋转，需要核心动画 CABaseAnimation
 
    */
    var refreshState: RefreshState = .Normal {
        didSet {
            switch refreshState {
            case .Normal:
                
                tipIcon.isHidden = false
                indicator.stopAnimating()
                
                tipLabel.text = "下拉刷新"
                
                UIView.animate(withDuration: 0.25, animations: { 
                    self.tipIcon.transform = CGAffineTransform.identity
                })
                
                
            case .Pulling:
                tipLabel.text = "释放刷新"
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.tipIcon.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI - 0.001))
                })
                
            case .WillRefresh:
                tipLabel.text = "加载中..."
                
                tipIcon.isHidden = true
                
                indicator.startAnimating()
            }
        }
    }
    
    
    @IBOutlet weak var tipIcon: UIImageView!
    
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    class func refreshView()-> LLRefreshView {
        let nib = UINib(nibName: "LLRefreshView", bundle: nil)
        return nib.instantiate(withOwner: nib, options: nil)[0] as! LLRefreshView
        
    }

}
