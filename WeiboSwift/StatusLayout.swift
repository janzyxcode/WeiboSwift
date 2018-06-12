//
//  StatusLayoutModel.swift
//  WeiboSwift
//
//  Created by  user on 2018/6/12.
//  Copyright © 2018年 nailiao. All rights reserved.
//

import Foundation

private var margin: CGFloat = 12
private var vipIconWidth: CGFloat = 15
var statusNameFontSize: CGFloat = 15
var statusTimeFontSize: CGFloat = 10

class StatusLayout {
    var topContainerViewLayout = CGRect.zero
    var topLineLayout = CGRect.zero
    var headerImgvLayout = CGRect.zero
    var nameLLayout = CGRect.zero
    var vipIconImgvLayout = CGRect.zero
    var timeLLayout = CGRect.zero
    var sourceLLayout = CGRect.zero
    var statusTextLayout = CGRect.zero
    var toolBarViewLayout = CGRect.zero
    var rowHeight: CGFloat!

    var statusTextAttr: NSAttributedString?

    init(status: StatusModel) {
        updateLayout(status: status)
    }

    func updateStatusTextLayout(size: CGSize) {

    }

    private func updateLayout(status: StatusModel) {
        // top
        topLineLayout = CGRect(x: 0, y: 0, width: screenWidth, height: 12)
        headerImgvLayout = CGRect(x: margin, y: topLineLayout.bottom + 12, width: 40, height: 40)
        vipIconImgvLayout = CGRect(x: headerImgvLayout.trailing - vipIconWidth, y: headerImgvLayout.bottom - vipIconWidth, width: vipIconWidth, height: vipIconWidth)

        let nameSize = NSMutableAttributedString.singleLineSize(fontSize: statusNameFontSize, status.user?.screen_name)
        nameLLayout = CGRect(x: headerImgvLayout.trailing + 12, y: headerImgvLayout.y, width: nameSize.width, height: nameSize.height)


        //FIXME:
        let timeSize = NSMutableAttributedString.singleLineSize(fontSize: statusTimeFontSize, "2018-11-11")
        timeLLayout = CGRect(x: nameLLayout.x, y: nameLLayout.bottom + 12, width: timeSize.width, height: timeSize.height)

        let sourceSize = NSMutableAttributedString.singleLineSize(fontSize: statusTimeFontSize, status.source)
        sourceLLayout = CGRect(x: timeLLayout.trailing + 12, y: timeLLayout.y, width: sourceSize.width, height: sourceSize.height)

        topContainerViewLayout = CGRect(x: 0, y: 0, width: screenWidth, height: headerImgvLayout.bottom + 12)

        // text
        if let statusText = status.text {
            let statusAttr = NSMutableAttributedString(string: statusText)

            let paraStyle = NSMutableParagraphStyle()
            paraStyle.lineSpacing = 12

            let attributes = [NSAttributedStringKey.paragraphStyle: paraStyle, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)]

            for key in attributes.keys {
                if let value = attributes[key] {
                    statusAttr.addAttribute(key, value: value, range: NSRange(location: 0, length: statusText.count))
                }
            }

            let statusTextSize = (statusText as NSString).boundingRect(with: CGSize(width: screenWidth - 2*margin, height: 1000), options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size

            statusTextAttr = statusAttr
            statusTextLayout = CGRect(x: margin, y: topContainerViewLayout.height, width: statusTextSize.width, height: statusTextSize.height)
            printLog(statusText)
            printLog(statusTextSize)
        }

        // tool
        if statusTextLayout.equalTo(CGRect.zero) {
            toolBarViewLayout = CGRect(x: 0, y: topContainerViewLayout.bottom + margin, width: screenWidth, height: 35)
        } else {
            toolBarViewLayout = CGRect(x: 0, y: statusTextLayout.bottom + margin, width: screenWidth, height: 35)
        }


        // height
        rowHeight = toolBarViewLayout.bottom
    }
}
