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
    private var headerImgv: UIImageView!
//    private var headerMaskImgv: UIImageView!
    private var nameL: UILabel!
    private var vipIconImgv: UIImageView!
    private var timeL: UILabel!
    private var sourceL: UILabel!
    private var statusL: UILabel!
    private var toolBarView: StatusToolBarView!
    private var retweetedStatusL: UILabel!
    private var retweetedView: UIView!
    var picturesView: StatusPicturesView!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        //
        topContainerView = UIView()
        contentView.addSubview(topContainerView)

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
        toolBarView = StatusToolBarView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 35))
        contentView.addSubview(toolBarView)

        picturesView = StatusPicturesView(frame: CGRect.zero)
        contentView.addSubview(picturesView)

        selectionStyle = .gray
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
        nameL.text = statusViewModel.status.user?.screen_name
        retweetedStatusL.attributedText = statusViewModel.layout.retweetedStatusTextAttr
        
        if let vipconName = statusViewModel.vipIconName {
            vipIconImgv.image = UIImage(named: vipconName)
        }

        headerImgv.setImage(urlString: statusViewModel.status.user?.profile_image_url, placeholderImage: UIImage(named: "avatar_default_big"), true)
        

        toolBarView.setContent(retweetedStr: statusViewModel.retweetedStr, commentStr: statusViewModel.commentStr, likeStr: statusViewModel.likeStr)
        sourceL.text = statusViewModel.statusSource
        timeL.text = statusViewModel.statusCreatedAt

        picturesView.setPictures(statusViewModel.picURLs, statusViewModel.pictureViews)
    }
//
//    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
//        super.setHighlighted(highlighted, animated: animated)
//        printLog("-----")
//    }
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
            let url = pictures[item.offset].bmiddle_pic
            item.element.setImage(urlString: url, placeholderImage: nil)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
