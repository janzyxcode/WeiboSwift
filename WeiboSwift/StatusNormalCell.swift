//
//  StatusNormalCell.swift
//  WeiboSwift
//
//  Created by  user on 2018/6/12.
//  Copyright © 2018年 nailiao. All rights reserved.
//

import UIKit

class StatusNormalCell: UITableViewCell, Reusable {
    private var topContainerView: UIView!
    private var topLineView: UIView!
    private var headerImgv: UIImageView!
    private var nameL: UILabel!
    private var vipIconImgv: UIImageView!
    private var timeL: UILabel!
    private var sourceL: UILabel!
    private var statusL: UILabel!
    private var toolBarView: UIView!

//    var memberIconView: UIImageView!
//    var pictureView: WBStatusPictureView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        //
        topContainerView = UIView()
        contentView.addSubview(topContainerView)

        topLineView = UIView()
        topLineView.backgroundColor = rgba(245, 245, 245)
        topContainerView.addSubview(topLineView)

        headerImgv = UIImageView()
        topContainerView.addSubview(headerImgv)

        nameL = UILabel()
        nameL.font = UIFont.systemFont(ofSize: statusNameFontSize)
        nameL.textColor = rgba(242, 62, 0)
        topContainerView.addSubview(nameL)

        timeL = UILabel()
        timeL.font = UIFont.systemFont(ofSize: statusTimeFontSize)
        timeL.textColor = rgba(255, 108, 0)
        topContainerView.addSubview(timeL)

        sourceL = UILabel()
        sourceL.font = UIFont.systemFont(ofSize: statusTimeFontSize)
        sourceL.textColor = rgba(130, 130, 130)
        topContainerView.addSubview(sourceL)

        //
        statusL = UILabel()
        statusL.numberOfLines = 0
        statusL.textColor = rgba(40, 40, 40)
        contentView.addSubview(statusL)

        //
        toolBarView = UIView()
        toolBarView.backgroundColor = UIColor.lightGray
        contentView.addSubview(toolBarView)

        
        // 离屏渲染 － 异步绘制
        self.layer.drawsAsynchronously = true
        // 栅格话 － 异步会址之后，会生出一张独立的图像，cell在屏幕上滚动的时候，本质上滚动的是这张图片
        // cell 优化，要尽量减少图层的数量，相当于就只有一层
        // 停止滚动之后，可以接收监听
        self.layer.shouldRasterize = true
        // 使用 ‘栅格化’ 必须注意指定分辨率
        self.layer.rasterizationScale = UIScreen.main.scale
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setStatus(_ statusViewModel: StatusViewModel) {
        topContainerView.frame = statusViewModel.layout.topContainerViewLayout
        topLineView.frame = statusViewModel.layout.topLineLayout
        headerImgv.frame = statusViewModel.layout.headerImgvLayout
        nameL.frame = statusViewModel.layout.nameLLayout
        timeL.frame = statusViewModel.layout.timeLLayout
        sourceL.frame = statusViewModel.layout.sourceLLayout
        statusL.frame = statusViewModel.layout.statusTextLayout
        toolBarView.frame = statusViewModel.layout.toolBarViewLayout

        statusL.attributedText = statusViewModel.layout.statusTextAttr
//        retweetedLabel?.attributedText = viewModel?.reweetedAttrText
        nameL.text = statusViewModel.status.user?.screen_name

//        vipIconImgv.image = statusViewModel.vipIcon
//        memberIconView.image = viewModel?.memberIcon

        headerImgv.setImage(urlString: statusViewModel.status.user?.profile_image_url, placeholderImage: UIImage(named: "avatar_default_big"), isAvatar: true)

//        toolBar.viewModel = viewModel

        // 配图视图模型
//        pictureView.viewModel = viewModel

        sourceL.text = statusViewModel.status.source

        //            timeLabel.text = viewModel?.status.createdDate?.ll_dateDescription
    }
}
