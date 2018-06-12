//
//  StatusViewModel.swift
//  WeiboSwift
//
//  Created by  user on 2018/6/12.
//  Copyright © 2018年 nailiao. All rights reserved.
//

import Foundation

struct StatusViewModel {

    var status: StatusModel
    var layout: StatusLayout

    var memberIcon:UIImage?
    var vipIcon: UIImage?

    var retweetedStr: String?
    var commentStr: String?
    var likeStr: String?

    var pictureViewSize = CGSize()

    // 如果是被转发的微博，原创微博已定没有图
    var picURLs: [StatusPictureModel]? {
        // 如果有被转发的微博，返回被转发微博的配图
        return status.retweeted_status?.pic_urls ?? status.pic_urls
    }

//    var reweetedTextAttr: NSAttributedString?

    init(status: StatusModel) {
        self.status = status
        self.layout = StatusLayout(status: status)

         if let user = status.user {
            setUserInfo(user)
        }

        retweetedStr = countString(count: status.resosts_count.value, defaultStr: "转发")
        commentStr = countString(count: status.comments_count.value, defaultStr: "评论")
        likeStr = countString(count: status.attitudes_count.value, defaultStr: "赞")

        pictureViewSize = calcPictureViewSize(count: picURLs?.count)

//        let originalFont = UIFont.systemFont(ofSize: 15)
//        let retweetedFont = UIFont.systemFont(ofSize: 14)

//        let statusText = status.text ?? ""
        //FIXME:???
//        statusAttrText = LLEmoticonManager.shared.emoticonString(string: statusText, font: originalFont)


//        let screenName = status.retweeted_status?.user?.screen_name ?? ""
//        let text = status.retweeted_status?.text ?? ""
//        let rText = "@" + screenName + ":" + text
//        reweetedAttrText = LLEmoticonManager.shared.emoticonString(string: rText, font: retweetedFont)

        updateRowHeight()
    }

    private mutating func setUserInfo(_ user: UserModel) {
        if user.mbrank > 0
            && user.mbrank < 7  {
            let imageName = "common_icon_membership_level\(user.mbrank)"
            memberIcon = UIImage(named: imageName)
        }

        switch user.verified_type {
        case 0:
            vipIcon = UIImage(named: "avatar_vip")
        case 2,3,5:
            vipIcon = UIImage(named: "avatar_enterprise_vip")
        case 220:
            vipIcon = UIImage(named: "avatar_grassroot")
        default:
            break
        }
    }

    private func countString(count: Int, defaultStr: String) -> String {
        if count == 0 {
            return defaultStr
        }

        if count < 10000 {
            return count.description
        }
        return String(format: "%.2f 万", Double(count) / 10000)
    }

    private func calcPictureViewSize(count: Int?) -> CGSize {
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
    mutating func updateSingleImageSize(image: UIImage) {
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
        updateRowHeight()
    }

    func updateRowHeight() {

//        // 原创微博：顶部分隔视图(12) ＋ 间距(12) ＋ 图片的高度(34) ＋ 间距(12) ＋ 正文高度(需要计算) ＋ 配图视图(高度需要计算) ＋ 间距(12) ＋ 底部视图高度(35)
//
//        // 被转发微博：顶部分隔视图(12) ＋ 间距(12) ＋ 图片的高度(34) ＋ 间距(12) ＋ 正文高度(需要计算) ＋ 间距(12) ＋ 间距(12) ＋ 转发文本(高度需要计算) ＋ 配图视图(高度需要计算) ＋ 间距(12) ＋ 底部视图高度(35)
//
//
//        let margin: CGFloat = 12
//        let iconHeight: CGFloat = 34
//        let toolbarHeight: CGFloat = 35
//
//        var height: CGFloat = 0
//
//        let viewSize = CGSize(width: UIScreen.main.bounds.width - 2 * margin, height: CGFloat(MAXFLOAT))
//
//
//        height = 2 * margin + iconHeight + margin
//
//        // 正文高度
//        if let text = statusAttrText {
//
//            // usesLineFragmentOrigin：换行文本，统一使用
//            height += text.boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], context: nil).height
//
//        }
//
//        // 判断是否转发微博
//        if status.retweeted_status != nil {
//
//            height += 2 * margin
//
//            // 转发文本的高度
//            if let text = reweetedAttrText {
//                height += text.boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], context: nil).height
//            }
//        }
//
//        height += pictureViewSize.height
//        height += margin
//        height += toolbarHeight
//
////        rowHeight = height
    }
}
