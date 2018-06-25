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

let elementTextColor = rgba(93, 118, 154)

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
    lazy var textAttrbutes = [[NSAttributedStringKey: Any]]()
    lazy var textAttrbuteRanges = [NSRange]()

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
            let statusTuple = emoticonString(layout: self, content: statusText, fontSize: 15, textColor: rgba(48, 48, 48))
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

                let retweetedStatusTuple = emoticonString(layout: self, content: rText, fontSize: 14, textColor: rgba(48, 48, 48))
                retweetedStatusTextAttr = retweetedStatusTuple.attr
                retweetedStatusTextLayout = CGRect(x: statusMargin, y: statusMargin, width: statusContentWidth, height: retweetedStatusTuple.size.height)
                retweetedLayout = CGRect(x: 0, y: topContainerViewLayout.bottom, width: screenWidth, height: retweetedStatusTuple.size.height + 2*statusMargin)
                if retweetedStatusText.contains("预算") {
                    printLog(retweetedStatusText)
                    printLog(retweetedLayout)
                    printLog(retweetedStatusTextLayout)
                    printLog(retweetedStatusTextAttr?.string)
                }
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

    func addAttributes(attr: [NSAttributedStringKey: NSObject], range: NSRange, _ isFirstIn: Bool = false) {
        if isFirstIn {
            textAttrbutes.insert(attr, at: 0)
            textAttrbuteRanges.insert(range, at: 0)
        } else {
            textAttrbutes.append(attr)
            textAttrbuteRanges.append(range)
        }
    }
}

extension StatusLayout {
    func emoticonString(layout: StatusLayout ,content: String, fontSize: CGFloat, textColor: UIColor) -> (attr: NSAttributedString, size: CGSize) {

        layout.textAttrbutes.removeAll()
        layout.textAttrbuteRanges.removeAll()
        let urlTuple = searchUrls(content, layout: layout)
        let fullTexttuple = searchFullTextIndex(urlTuple.str, layout: layout)
        let attr = fullTexttuple.attr
        let attrString = attr.string

        let eleDict = [NSAttributedStringKey.foregroundColor: elementTextColor]
        if fullTexttuple.isChanged {
            layout.addAttributes(attr: eleDict, range: fullTexttuple.range)
        }
        for item in urlTuple.ranges {
            if fullTexttuple.isChanged {
                if item.location < fullTexttuple.range.location {
                    layout.addAttributes(attr: eleDict, range: item)
                }
            } else {
                layout.addAttributes(attr: eleDict, range: item)
            }
        }

        for item in searchCallTip(attr) {
            layout.addAttributes(attr: eleDict, range: item)
        }

        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = 5

        let font = UIFont.systemFont(ofSize: fontSize)

        //
        let attributes = [NSAttributedStringKey.paragraphStyle: paraStyle,
                          NSAttributedStringKey.foregroundColor: textColor,
                          NSAttributedStringKey.font: font]

        for item in attributes {
            layout.addAttributes(attr: [item.key: item.value], range: NSRange(location: 0, length: attrString.count), true)
        }

        for item in layout.textAttrbutes.enumerated() {
            let range = layout.textAttrbuteRanges[item.offset]
            attr.addAttributes(item.element, range: range)
        }

        let width = statusContentWidth
        if content.contains("预算") {
            printLog(content)
            printLog(attrString)
        }
        let statusTextSize = (attrString as NSString).boundingRect(with: CGSize(width: width, height: 1000), options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size

        LLEmoticonManager.shared.replaceEmoticon(attr, attrString, font)

        return (attr, CGSize(width: width, height: statusTextSize.height))
    }

    // 全文
    private func searchFullTextIndex(_ content: String, layout: StatusLayout) -> (attr: NSMutableAttributedString, range: NSRange, isChanged: Bool) {

        var attr = NSMutableAttributedString(string: content)
        let pattern = "...全文： "

        guard let rr = content.range(of: pattern) else {
            return (attr, content.fullRange, false)
        }

        let range = NSRange(location: 0, length: rr.upperBound.encodedOffset)

        let changeContent = content.subString(range: NSRange(location: 0, length: range.length - 2))
        attr = NSMutableAttributedString(string: changeContent)

        //        let urlRange = NSRange(location: range.length, length: content.count - range.length - 1)
        //        printLog(content.subString(range: urlRange))

        let fullTextRange = NSRange(location: range.length - pattern.count + 3, length: 2)
        //        let attrDict = [NSAttributedStringKey.foregroundColor: elementTextColor]
        //        layout.addAttributes(attr: attrDict, range: fullTextRange)
        return (attr, fullTextRange, true)
    }

    private func searchUrls(_ content: String, layout: StatusLayout) -> (str: String, ranges: [NSRange], isChange: Bool) {
        let pattern = "((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
            return (content, [], false)
        }

        let array = regx.matches(in: content, options: [], range: content.fullRange)
        var str = content
        var reduceArray = [Int]()

        for item in array.reversed() {
            let range = item.range
            let subStr = content.subString(range: range)
            reduceArray.insert(subStr.count - 4, at: 0)
        }

        var rangeList = [NSRange]()
        for item in array.enumerated().reversed() {
            let range = item.element.range
            str = (str as NSString).replacingCharacters(in: range, with: "网页链接")
            var reduce = 0
            if item.offset > 0 {
                for i in 0...item.offset - 1 {
                    reduce += reduceArray[i]
                }
            }
            for item in reduceArray.enumerated() {
                if item.offset - 1 > item.offset {
                    reduce += item.element
                }
            }
            rangeList.append(NSRange(location: range.location - reduce, length: 4))
        }
        return (str,rangeList, true)
    }

    private func searchCallTip(_ attrString: NSMutableAttributedString) -> [NSRange] {
        let pattern = "@[0-9a-zA-Z\\u4e00-\\u9fa5]+"

        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
            return []
        }

        let matches = regx.matches(in: attrString.string, options: [], range: NSRange(location: 0, length: attrString.length))

        var ranges = [NSRange]()
        for m in matches {
            let r = m.range(at: 0)
            ranges.append(r)
        }
        return ranges
    }
}
