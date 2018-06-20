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
//    private var headerMaskImgv: UIImageView!
    private var nameL: UILabel!
    private var vipIconImgv: UIImageView!
    private var timeL: UILabel!
    private var sourceL: UILabel!
    private var statusL: UILabel!
    private var toolBarView: UIView!
    private var retweetedStatusL: UILabel!
    private var retweetedView: UIView!

    //    var memberIconView: UIImageView!
    var picturesView: StatusPicturesView!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        //
        topContainerView = UIView()
        contentView.addSubview(topContainerView)

        topLineView = UIView()
        topLineView.backgroundColor = rgba(238, 238, 238)
        topContainerView.addSubview(topLineView)

        headerImgv = UIImageView()
        topContainerView.addSubview(headerImgv)

//        headerMaskImgv = UIImageView(image: #imageLiteral(resourceName: "header_mask"))
//        topContainerView.addSubview(headerMaskImgv)

        vipIconImgv = UIImageView()
        topContainerView.addSubview(vipIconImgv)

        nameL = UILabel()
        nameL.font = UIFont.systemFont(ofSize: statusNameFontSize)
        nameL.textColor = rgba(48, 48, 48)
        topContainerView.addSubview(nameL)

        timeL = UILabel()
        timeL.font = UIFont.systemFont(ofSize: statusTimeFontSize)
        timeL.textColor = rgba(152, 152, 152)
        topContainerView.addSubview(timeL)

        sourceL = UILabel()
        sourceL.font = UIFont.systemFont(ofSize: statusTimeFontSize)
        sourceL.textColor = rgba(130, 130, 130)
        topContainerView.addSubview(sourceL)

        //
        statusL = UILabel()
        statusL.numberOfLines = 0
        topContainerView.addSubview(statusL)

        retweetedView = UIView()
        retweetedView.backgroundColor = rgba(247, 247, 247)
        contentView.addSubview(retweetedView)

        retweetedStatusL = UILabel()
        retweetedStatusL.numberOfLines = 0
        retweetedView.addSubview(retweetedStatusL)

        //
        toolBarView = UIView()
        toolBarView.backgroundColor = UIColor.lightGray
        contentView.addSubview(toolBarView)

        picturesView = StatusPicturesView(frame: CGRect.zero)
        contentView.addSubview(picturesView)

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
//        headerMaskImgv.frame = headerImgv.frame
        vipIconImgv.frame = statusViewModel.layout.vipIconImgvLayout
        nameL.frame = statusViewModel.layout.nameLLayout
        timeL.frame = statusViewModel.layout.timeLLayout
        sourceL.frame = statusViewModel.layout.sourceLLayout
        statusL.frame = statusViewModel.layout.statusTextLayout
        picturesView.frame = statusViewModel.layout.picturesViewLayout
        toolBarView.frame = statusViewModel.layout.toolBarViewLayout
        retweetedStatusL.frame = statusViewModel.layout.retweetedStatusTextLayout
        retweetedView.frame = statusViewModel.layout.retweetedLayout

        statusL.attributedText = statusViewModel.layout.statusTextAttr
        //        retweetedLabel?.attributedText = viewModel?.reweetedAttrText
        nameL.text = statusViewModel.status.user?.screen_name
        retweetedStatusL.attributedText = statusViewModel.layout.retweetedStatusTextAttr
        
        if let vipconName = statusViewModel.vipIconName {
            vipIconImgv.image = UIImage(named: vipconName)
        }
        //        memberIconView.image = viewModel?.memberIcon

        headerImgv.setImage(urlString: statusViewModel.status.user?.profile_image_url, placeholderImage: UIImage(named: "avatar_default_big"), true)
        

        //        toolBar.viewModel = viewModel

        // 配图视图模型
        //        pictureView.viewModel = viewModel

        sourceL.text = statusViewModel.statusSource
        timeL.text = statusViewModel.statusCreatedAt

        picturesView.setPictures(statusViewModel.picURLs, statusViewModel.pictureViews)
    }
}


class StatusPicturesView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    func setPictures(_ pictures: [StatusPictureModel]?, _ imageviews: [UIImageView]) {
        removeAllSubViews()
        guard let pictures = pictures else {
            return
        }

        for item in imageviews.enumerated() {
            addSubview(item.element)
            let url = pictures[item.offset].thumbnail_pic
            item.element.setImage(urlString: url, placeholderImage: nil)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
