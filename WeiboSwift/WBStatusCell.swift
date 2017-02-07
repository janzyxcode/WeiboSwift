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
            
            pictureView.heightCons.constant = viewModel?.pictureViewSize.height ?? 0
            pictureView.urls = viewModel?.status.pic_urls
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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
