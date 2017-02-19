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
    
    var statusAttrText: NSAttributedString?
    var reweetedAttrText: NSAttributedString?
    
    
    var pictureViewSize = CGSize()
    
    // 如果是被转发的微博，原创微博已定没有图
    var picURLs: [WBStatusPicture]? {
        // 如果有被转发的微博，返回被转发微博的配图
        return status.retweeted_status?.pic_urls ?? status.pic_urls
    }
    
    var rowHeight: CGFloat = 0
    
    
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
        
        pictureViewSize = calcPictureViewSize(count: picURLs?.count)
        
        
        let originalFont = UIFont.systemFont(ofSize: 15)
        let retweetedFont = UIFont.systemFont(ofSize: 14)
        
        statusAttrText = LLEmoticonManager.shared.emoticonString(string: model.text ?? "", font: originalFont)
        
        let rText = "@" + (status.retweeted_status?.user?.screen_name ?? "") + ":" + (status.retweeted_status?.text ?? "")
        
        reweetedAttrText = LLEmoticonManager.shared.emoticonString(string: rText, font: retweetedFont)
        
        updateRowHeight()
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
    
    
    // 使用单张图片，更新配图视图的大小
    func updateSingleImageSize(image: UIImage) {
        
        var size = image.size
        
        
        let maxWidth: CGFloat = 300
        let minWidth: CGFloat = 40
        
        // 过宽图片处理
        if size.width > maxWidth {
            size.width = 200
            size.height = size.width * image.size.height / image.size.width
        }
        
        // 过窄图片处理
        if size.width < minWidth {
            size.width = minWidth
            size.height = size.width * image.size.height / image.size.width / 4
        }
        
        size.height += WBStatusPictureViewOutterMargin
        
        pictureViewSize = size
        // 更新行高
        updateRowHeight()
    }
    
    // 根据当前视图模型内容计算行高
    func updateRowHeight() {
        
        // 原创微博：顶部分隔视图(12) ＋ 间距(12) ＋ 图片的高度(34) ＋ 间距(12) ＋ 正文高度(需要计算) ＋ 配图视图(高度需要计算) ＋ 间距(12) ＋ 底部视图高度(35)
        
        // 被转发微博：顶部分隔视图(12) ＋ 间距(12) ＋ 图片的高度(34) ＋ 间距(12) ＋ 正文高度(需要计算) ＋ 间距(12) ＋ 间距(12) ＋ 转发文本(高度需要计算) ＋ 配图视图(高度需要计算) ＋ 间距(12) ＋ 底部视图高度(35)
        
        
        let margin: CGFloat = 12
        let iconHeight: CGFloat = 34
        let toolbarHeight: CGFloat = 35
        
        var height: CGFloat = 0
        
        let viewSize = CGSize(width: UIScreen.main.bounds.width - 2 * margin, height: CGFloat(MAXFLOAT))
        
        
        height = 2 * margin + iconHeight + margin
        
        // 正文高度
        if let text = statusAttrText {
            
            // usesLineFragmentOrigin：换行文本，统一使用
            height += text.boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], context: nil).height
            
        }
        
        // 判断是否转发微博
        if status.retweeted_status != nil {
            
            height += 2 * margin
            
            // 转发文本的高度
            if let text = reweetedAttrText {
                height += text.boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], context: nil).height
            }
        }
        
        height += pictureViewSize.height
        height += margin
        height += toolbarHeight
        
        rowHeight = height
    }
    
    var description: String {
        return status.description
    }
    
    
    
    /**
 高级优化： 离屏渲染
          栅格化： 异步绘制之后，会生成一张独立的图像
          如果检测到cell的性能已经很好，就不需要离屏渲染，离屏渲染需要在GPU/CPU 之间快速切换，耗电会厉害
 
 
 */
    
}

