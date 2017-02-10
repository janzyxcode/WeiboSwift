//
//  JDRefreshControlView.swift
//  WeiboSwift
//
//  Created by mac on 17/2/10.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

class JDRefreshControlView: UIView {

    /// 刷新状态
  
    var refreshState: RefreshState = .Normal {
        didSet {
            switch refreshState {
            case .Normal:
                
                moveAction(state: .Normal)
                tipLabel.text = "下拉刷新..."
                
            case .Pulling:
                
                moveAction(state: .Pulling)
                tipLabel.text = "松手刷新..."
                
            case .WillRefresh:
                
                moveAction(state: .WillRefresh)
                tipLabel.text = "更新中..."
            }
        }
    }
    
    var pullRation: CGFloat = 0 {
        didSet {
            
            //FIXME:人物不是从下到上
            
            pullRation = fabs(pullRation)
            
            autoStaffImgv.transform = CGAffineTransform(scaleX: pullRation, y: pullRation)
            box.transform = CGAffineTransform(scaleX: pullRation, y: pullRation)
            

        }
    }
    
    

    func moveAction(state: RefreshState) {
        
        let normalState = state == .Normal ? true : false
        
        box.isHidden = !normalState
        autoStaffImgv.isHidden = !normalState
        deliveryStaffImgv.isHidden = normalState
        speed.isHidden = normalState
        
        if normalState != true {
            let image1 = #imageLiteral(resourceName: "deliveryStaff1")
            let image2 = #imageLiteral(resourceName: "deliveryStaff2")
            let image3 = #imageLiteral(resourceName: "deliveryStaff3")
            deliveryStaffImgv.image = UIImage.animatedImage(with: [image1,image2,image3], duration: 0.3)
        }
    }
    
    
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var box: UIImageView!
    
    @IBOutlet weak var speed: UIImageView!
    
    @IBOutlet weak var deliveryStaffImgv: UIImageView!
    
    @IBOutlet weak var autoStaffImgv: UIImageView!
    
    class func refreshView()-> JDRefreshControlView {
        let nib = UINib(nibName: "JDRefreshControlView", bundle: nil)
        return nib.instantiate(withOwner: nib, options: nil)[0] as! JDRefreshControlView

    }

}
