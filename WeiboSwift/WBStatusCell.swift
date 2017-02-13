//
//  WBStatusCell.swift
//  WeiboSwift
//
//  Created by mac on 17/2/7.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

class WBStatusCell: UITableViewCell {

    var viewModel: WBStatusViewModel? {
        didSet {
            statusLabel?.text = viewModel?.status.text
            nameLabel.text = viewModel?.status.user?.screen_name
            memberIconView.image = viewModel?.memberIcon
            vipIconView.image = viewModel?.vipIcon
            
            iconView.ll_setImage(urlString: viewModel?.status.user?.profile_image_url, placeholderImage: UIImage(named: "avatar_default_big"), isAvatar: true)
            
            toolBar.viewModel = viewModel
            
            // 配图视图模型
            pictureView.viewModel = viewModel
            
            
            retweetedLabel?.text = viewModel?.retweetedText
            
            sourceLabel.text = viewModel?.status.source
            
        }
    }
    
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
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var toolBar: WBStatusToolBar!
    
    @IBOutlet weak var pictureView: WBStatusPictureView!
    
   /// 被转发微博的标签 － 原创微博没有此控件，一定要用 ‘？’
    @IBOutlet weak var retweetedLabel: UILabel?
    
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
    }


    
    
    /**
 正则表达式： ‘匹配’字符串，进行模糊查找
     .     匹配任意字符，回车除外
     *     匹配任意多次
     ?     尽量少的匹配
 
     不是OC特有，几乎所有的语言/IDE，都支持正则表达式
 */
}
