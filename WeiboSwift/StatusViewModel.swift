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

    var vipIconName: String?

    var retweetedStr: String?
    var commentStr: String?
    var likeStr: String?

    var pictureViews = [StatusPictureImageView]()
    var pictureViewSize = CGSize.zero
    var isLongPicture = false

    var picURLs: [StatusPictureModel]? {
        return status.retweeted_status?.pic_urls ?? status.pic_urls
    }

    init(status: StatusModel) {
        self.status = status
        self.layout = StatusLayout(status: status)

        if let user = status.user {
            setUserInfo(user)
        }

        statusCreatedAt = Date.createdAtDeal(status.created_at)
        layout.updateTimeLayout(timeStr: statusCreatedAt)
        if let sourceTuple = sourceHref(status.source) {
            statusSource = "来自" + sourceTuple.text
            layout.updateSourceLayout(sourceStr: statusSource)
        }

        retweetedStr = countString(count: status.resosts_count.value, defaultStr: "转发")
        commentStr = countString(count: status.comments_count.value, defaultStr: "评论")
        likeStr = countString(count: status.attitudes_count.value, defaultStr: "赞")

        calcPictureViewSize()
    }

    private func setUserInfo(_ user: UserModel) {
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
            let tag = item.offset + 10

            let imgv = StatusPictureImageView(frame: CGRect.zero)
            imgv.tag = tag
            imgv.isGif = item.element.isGif
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

    func updateSingleImageSize(_ imageSize: CGSize, _ imageView: StatusPictureImageView) {
        isLongPicture = imageSize.width / imageSize.height < 0.4

        var size = imageSize
        if !isLongPicture {

            var imageScale = imageSize.width / imageSize.height
            if imageScale < 1 {
                let maxWidth = (screenWidth - statusMargin * 3) * 0.5
                imageScale = imageScale < 0.9 ? 0.9 : imageScale
                size = CGSize(width: maxWidth, height: maxWidth / imageScale)
                printLog("\(imageScale)    \(size)    ")
            } else if imageScale > 1 {
                let maxWidth = screenWidth - statusMargin * 2
                let maxHeight = (screenWidth - statusMargin * 3) * 0.5
                let width = maxHeight * imageScale
                if width > maxWidth {
                    size = CGSize(width: maxWidth, height: maxWidth / imageScale)
                } else if width <= maxWidth {
                    size = CGSize(width: maxHeight * imageScale, height: maxHeight)
                }
            } else if imageScale == 1 {
                let maxWidth = (screenWidth - statusMargin * 2) * 0.6
                size = CGSize(width: maxWidth, height: maxWidth)
            }

        } else {
            imageView.isLongPicture = true
            let width = (screenWidth - statusMargin*3) * 0.4
            let height = width * 1.2
            size = CGSize(width: width, height: height)
        }

        size.height += statusMargin
        imageView.frame = CGRect.originFromRect(size)
        pictureViewSize = size
        layout.updateStatusTextLayoutWith(pictureViewsize: pictureViewSize)
    }
}
