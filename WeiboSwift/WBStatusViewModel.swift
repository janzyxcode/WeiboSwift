//
//  WBStatusViewModel.swift
//  WeiboSwift
//
//  Created by mac on 17/2/7.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import Foundation

/**
 如果没有任何父类，如果希望在开发时调试，输出调试信息，需要
 1、遵守 CustomStringConvertible
 2、实现 description 计算型属性
 */




/**
 关于表格的性能优化
 －尽量少计算，所有需要的素材提前计算号
 －控件上不要设置圆角半径，所有图像渲染的属性，都要注意
 －不要动态创建控件，所有需要的空间，都要提前创建号，在显示的时候，更加数据隐藏／显示！
 －Cell 中的控件的层次越少越好，数量越少越好
 －要测量，不要猜测
 */

class WBStatusViewModel: CustomStringConvertible {
    
    // 微博模型
    var status: WBStatus
    
    // 会员图标 － 存储型属性（用内存换 CPU）
    var memberIcon:UIImage?
    var vipIcon: UIImage?
    
    var retweetedStr: String?
    var commentStr: String?
    var likeStr: String?
    
    var pictureViewSize = CGSize()
    
    init(model: WBStatus) {
        self.status = model
        
        if (model.user?.mbrank)! > 0
            && (model.user?.mbrank)! < 7  {
            let imageName = "common_icon_membership_level\(model.user?.mbrank ?? 1)"
            memberIcon = UIImage(named: imageName)
        }
        
        
        switch model.user?.verified_type ?? -1 {
        case 0:
            vipIcon = UIImage(named: "avatar_vip")
        case 2,3,5:
            vipIcon = UIImage(named: "avatar_enterprise_vip")
        case 220:
            vipIcon = UIImage(named: "avatar_grassroot")
        default:
            break
        }
        
        retweetedStr = countString(count: model.resosts_count, defaultStr: "转发")
        commentStr = countString(count: model.comments_count, defaultStr: "评论")
        likeStr = countString(count: model.attitudes_count, defaultStr: "赞")
        
        pictureViewSize = calcPictureViewSize(count: status.pic_urls?.count)
    }
    
    
    func countString(count: Int, defaultStr: String) -> String {
        
        if count == 0 {
            return defaultStr
        }
        
        if count < 10000 {
            return count.description
        }
        
        return String(format: "%.2f 万", Double(count) / 10000)
    }
    
    func calcPictureViewSize(count: Int?) -> CGSize {
        
        if count == 0 || count == nil {
            return CGSize()
        }
        
        
        let row = (count! - 1) / 3 + 1
        
        var height = WBStatusPictureViewOutterMargin
        height += CGFloat(row) * WBStatusPictureItemWidth
        height += CGFloat(row - 1) * WBStatusPictureViewInnerMargin
        
        return CGSize(width: WBStatusPictureViewWidth, height: height)
    }
    
    var description: String {
        return status.description
    }

}

