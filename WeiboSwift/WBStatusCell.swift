//
//  WBStatusCell.swift
//  WeiboSwift
//
//  Created by mac on 17/2/7.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit
import FFLabel


@objc protocol WBstatusCellDelegate: NSObjectProtocol {
    
   @objc optional func statusCellDidSelectedURLString(cell: WBStatusCell, urlString: String)
}

class WBStatusCell: UITableViewCell {
    
    var viewModel: WBStatusViewModel? {
        didSet {
//            statusLabel?.attributedText = viewModel?.statusAttrText
//            retweetedLabel?.attributedText = viewModel?.reweetedAttrText
//
//            nameLabel.text = viewModel?.status.user?.screen_name
//            memberIconView.image = viewModel?.memberIcon
//            vipIconView.image = viewModel?.vipIcon
//
//            iconView.setImage(urlString: viewModel?.status.user?.profile_image_url, placeholderImage: UIImage(named: "avatar_default_big"), isAvatar: true)
//
//            toolBar.viewModel = viewModel
//
//            // 配图视图模型
//            pictureView.viewModel = viewModel
//
//
//            sourceLabel.text = viewModel?.status.source
//
////            timeLabel.text = viewModel?.status.createdDate?.ll_dateDescription
        }
    }
    
    weak var delegate: WBstatusCellDelegate?
    
    // 头像
    @IBOutlet weak var iconView: UIImageView!
    // 姓名
    @IBOutlet weak var nameLabel: UILabel!
    // 时间
    @IBOutlet weak var timeLabel: UILabel!
    // 来源
    @IBOutlet weak var sourceLabel: UILabel!
    // 会员图标
    @IBOutlet weak var memberIconView: UIImageView!
    // 认证图标
    @IBOutlet weak var vipIconView: UIImageView!
    // 微博正文
    @IBOutlet weak var statusLabel: FFLabel!
    
    @IBOutlet weak var toolBar: WBStatusToolBar!
    
    @IBOutlet weak var pictureView: WBStatusPictureView!
    
    /// 被转发微博的标签 － 原创微博没有此控件，一定要用 ‘？’
    @IBOutlet weak var retweetedLabel: FFLabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 离屏渲染 － 异步绘制
        self.layer.drawsAsynchronously = true
        
        // 栅格话 － 异步会址之后，会生出一张独立的图像，cell在屏幕上滚动的时候，本质上滚动的是这张图片
        // cell 优化，要尽量减少图层的数量，相当于就只有一层
        // 停止滚动之后，可以接收监听
        self.layer.shouldRasterize = true
        
        // 使用 ‘栅格化’ 必须注意指定分辨率
        self.layer.rasterizationScale = UIScreen.main.scale
        
        
        statusLabel.labelDelegate = self
        retweetedLabel?.labelDelegate = self
    }
    
}


extension WBStatusCell: FFLabelDelegate {
    
    func labelDidSelectedLinkText(label: FFLabel, text: String) {
        
        if !text.hasPrefix("http://") {
            return
        }
        
        // 插入 ？ 表示如果代理没有实现协议方法，就什么都不要做
        // 如果使用 ！，代理没有实现协议方法，仍然强行执行，会崩溃！
        delegate?.statusCellDidSelectedURLString?(cell: self, urlString: text)
        
    }
    
}
