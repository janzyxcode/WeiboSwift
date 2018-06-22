//
//  StatusLayoutModel.swift
//  WeiboSwift
//
//  Created by  user on 2018/6/12.
//  Copyright © 2018年 nailiao. All rights reserved.
//

import UIKit

let statusMargin: CGFloat = 12
var statusContentWidth = screenWidth - 2*statusMargin

private var vipIconWidth: CGFloat = 15
var statusNameFontSize: CGFloat = 15
var statusTimeFontSize: CGFloat = 10

class StatusLayout {
    var status: StatusModel!
    var topContainerViewLayout = CGRect.zero
    var headerImgvLayout = CGRect.zero
    var nameLLayout = CGRect.zero
    var vipIconImgvLayout = CGRect.zero
    var timeLLayout = CGRect.zero
    var sourceLLayout = CGRect.zero
    var statusTextLayout = CGRect.zero
    var toolBarViewLayout = CGRect.zero
    var picturesViewLayout = CGRect.zero

    var retweetedLayout = CGRect.zero
    var retweetedStatusTextAttr: NSAttributedString?
    var retweetedStatusTextLayout = CGRect.zero

    var rowHeight: CGFloat!
    var statusTextAttr: NSAttributedString?

    init(status: StatusModel) {
        self.status = status
        updateLayout()
    }

    func updateStatusTextLayoutWith(pictureViewsize: CGSize) {
        
        if status.retweeted_status == nil {
            picturesViewLayout = CGRect(x: statusMargin, y: topContainerViewLayout.bottom, width: pictureViewsize.width, height: pictureViewsize.height)
        } else {
            picturesViewLayout = CGRect(x: statusMargin, y: retweetedLayout.y + retweetedStatusTextLayout.bottom + statusMargin, width: pictureViewsize.width, height: pictureViewsize.height)
            retweetedLayout = CGRect(x: 0, y: topContainerViewLayout.bottom, width: screenWidth, height: picturesViewLayout.bottom + statusMargin - topContainerViewLayout.bottom)
        }
        updateBottomLayout()
    }

    private func updateLayout() {
        updateTopLayout()
        picturesViewLayout = CGRect(x: 0, y: topContainerViewLayout.bottom, width: screenWidth, height: 0)
        updateRetweetedLayout()
        updateBottomLayout()
    }

    func updateTimeLayout(timeStr: String?) {
        let timeSize = NSMutableAttributedString.singleLineSize(fontSize: statusTimeFontSize, timeStr)
        timeLLayout = CGRect(x: nameLLayout.x, y: nameLLayout.bottom + 6, width: timeSize.width, height: timeSize.height)
    }

    func updateSourceLayout(sourceStr: String?) {
        let sourceSize = NSMutableAttributedString.singleLineSize(fontSize: statusTimeFontSize, sourceStr)
        sourceLLayout = CGRect(x: timeLLayout.trailing + statusMargin, y: timeLLayout.y, width: sourceSize.width, height: sourceSize.height)
    }

    private func updateTopLayout() {
        // top
        headerImgvLayout = CGRect(x: statusMargin, y: statusMargin, width: 40, height: 40)
        vipIconImgvLayout = CGRect(x: headerImgvLayout.trailing - vipIconWidth, y: headerImgvLayout.bottom - vipIconWidth, width: vipIconWidth, height: vipIconWidth)

        let nameSize = NSMutableAttributedString.singleLineSize(fontSize: statusNameFontSize, status.user?.screen_name)
        nameLLayout = CGRect(x: headerImgvLayout.trailing + statusMargin, y: headerImgvLayout.y + 3, width: nameSize.width, height: nameSize.height)

        // text
        if let statusText = status.text {
            let statusTuple = LLEmoticonManager.shared.emoticonString(content: statusText, fontSize: 15, textColor: rgba(48, 48, 48))
            statusTextAttr = statusTuple.attr
            statusTextLayout = CGRect(x: statusMargin, y: headerImgvLayout.bottom + statusMargin, width: statusContentWidth, height: statusTuple.size.height)
        }

        topContainerViewLayout = CGRect(x: 0, y: 0, width: screenWidth, height: statusTextLayout.bottom + statusMargin)
    }

    private func updateRetweetedLayout() {
        if status.retweeted_status != nil {
            if let retweetedStatusText = status.retweeted_status?.text {
                let screenName = status.retweeted_status?.user?.screen_name ?? ""
                let rText = "@" + screenName + ":" + retweetedStatusText

                let retweetedStatusTuple = LLEmoticonManager.shared.emoticonString(content: rText, fontSize: 14, textColor: rgba(48, 48, 48))
                retweetedStatusTextAttr = retweetedStatusTuple.attr
                retweetedStatusTextLayout = CGRect(x: statusMargin, y: statusMargin, width: statusContentWidth, height: retweetedStatusTuple.size.height)
                retweetedLayout = CGRect(x: 0, y: topContainerViewLayout.bottom, width: screenWidth, height: retweetedStatusTuple.size.height + 2*statusMargin)
            }
        }
    }

    private func updateBottomLayout() {
        if status.retweeted_status != nil {
            toolBarViewLayout = CGRect(x: 0, y: retweetedLayout.height + topContainerViewLayout.bottom, width: screenWidth, height: 35.5 + statusMargin)
        } else {
            let y = picturesViewLayout.bottom + (picturesViewLayout.height == 0 ? 0 : statusMargin)
            toolBarViewLayout = CGRect(x: 0, y: y, width: screenWidth, height: 35.5 + statusMargin)
        }

        rowHeight = toolBarViewLayout.bottom
    }
}
