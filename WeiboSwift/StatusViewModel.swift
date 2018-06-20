//
//  StatusViewModel.swift
//  WeiboSwift
//
//  Created by  user on 2018/6/12.
//  Copyright © 2018年 nailiao. All rights reserved.
//

import UIKit

private let picturesLimitCount = 9
let statusPictureMargin: CGFloat = 5
private let rowPictureLimitCount = 3
var statusPictureItemWidth = (statusContentWidth - 2*statusPictureMargin) / rowPictureLimitCount.cgFloatValue


class StatusViewModel {

    var status: StatusModel
    var layout: StatusLayout

    var statusSource: String?
    var statusCreatedAt: String?

    var memberIconName: String?
    var vipIconName: String?

    var retweetedStr: String?
    var commentStr: String?
    var likeStr: String?

    var pictureViews = [UIImageView]()
    var pictureViewSize = CGSize.zero

    var picURLs: [StatusPictureModel]? {
        return status.retweeted_status?.pic_urls ?? status.pic_urls
    }

    init(status: StatusModel) {
        self.status = status
        self.layout = StatusLayout(status: status)

        if let user = status.user {
            setUserInfo(user)
        }

        if let sourceTuple = sourceHref(status.source) {
            statusSource = "来自" + sourceTuple.text
        }
        statusCreatedAt = Date.createdAtDeal(status.created_at)
        
        retweetedStr = countString(count: status.resosts_count.value, defaultStr: "转发")
        commentStr = countString(count: status.comments_count.value, defaultStr: "评论")
        likeStr = countString(count: status.attitudes_count.value, defaultStr: "赞")

        calcPictureViewSize()
    }

    private func setUserInfo(_ user: UserModel) {
        if user.mbrank > 0
            && user.mbrank < 7  {
            let imageName = "common_icon_membership_level\(user.mbrank)"
            memberIconName = imageName
        }

        switch user.verified_type {
        case 0:
            vipIconName = "avatar_vip"
        case 2,3,5:
            vipIconName = "avatar_enterprise_vip"
        case 220:
            vipIconName = "avatar_grassroot"
        default:
            break
        }
    }

    private func sourceHref(_ source: String?) -> (link: String, text: String)? {
        guard let source = source else {
            return nil
        }
        let pattern = "<a href=\"(.*?)\".*?>(.*?)</a>"
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []), let result = regx.firstMatch(in: source, options: [], range: NSRange(location: 0, length: source.count))
            else {
                return nil
        }

        let link = source.subString(range: result.range(at: 1))
        let text = source.subString(range: result.range(at: 2))
        return (link, text)
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

    private func calcPictureViewSize() {
        guard let pictureUrls = picURLs else {
            return
        }

        for item in pictureUrls.enumerated() {
            let imgv = UIImageView()
            imgv.tag = item.offset
            pictureViews.append(imgv)
            if item.offset == picturesLimitCount - 1 {
                break
            }
        }

        if pictureUrls.count > 1 {
            var count = pictureUrls.count
            if count > picturesLimitCount {
                count = picturesLimitCount
            }

            var height: CGFloat = 0

            for i in 0..<count {
                let x = (i % rowPictureLimitCount).cgFloatValue * (statusPictureItemWidth + statusPictureMargin)
                let y = (i / rowPictureLimitCount).cgFloatValue * (statusPictureItemWidth + statusPictureMargin)
                let imgvFrame = CGRect(x: x, y: y, width: statusPictureItemWidth, height: statusPictureItemWidth)
                pictureViews[i].frame = imgvFrame
                height = imgvFrame.bottom
            }

            pictureViewSize = CGSize(width: statusContentWidth, height: height)
            layout.updateStatusTextLayoutWith(pictureViewsize: pictureViewSize)
        }
    }

    func updateSingleImageSize(_ imageSize: CGSize, _ imageView: UIImageView) {
        var size = imageSize
        let maxWidth: CGFloat = 300
        let minWidth: CGFloat = 40

        if size.width > maxWidth {
            size.width = 200
            size.height = size.width * imageSize.height / imageSize.width
        }

        if size.width < minWidth {
            size.width = minWidth
            size.height = size.width * imageSize.height / imageSize.width / 4
        }

        imageView.frame = CGRect.originFromRect(size)
        size.height += statusMargin
        pictureViewSize = size
        layout.updateStatusTextLayoutWith(pictureViewsize: pictureViewSize)
    }
}
