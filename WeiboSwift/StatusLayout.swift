//
//  StatusLayoutModel.swift
//  WeiboSwift
//
//  Created by  user on 2018/6/12.
//  Copyright © 2018年 nailiao. All rights reserved.
//

import UIKit

let statusMargin: CGFloat = 12
let statusContentWidth = screenWidth - 2*statusMargin

private let vipIconWidth: CGFloat = 15
let statusNameFontSize: CGFloat = 15
let statusTimeFontSize: CGFloat = 10
let statusTextFontSize: CGFloat = 15
let retweetedTextFontSize: CGFloat = 14
let statusSingleLineHeight = NSMutableAttributedString.singleLineSize(fontSize: statusTextFontSize).height
let retweetedSingleLineHeight = NSMutableAttributedString.singleLineSize(fontSize: retweetedTextFontSize).height

let elementTextColor = rgba(93, 118, 154)

@objc protocol StatusLayoutDelegate: NSObjectProtocol {
    @objc optional func StatusLayoutDidClickUrl(urlStr: String)
}

class StatusLayout {
    weak var delegate: StatusLayoutDelegate?
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
            let statusTuple = emoticonString(layout: self, content: statusText, fontSize: statusTextFontSize, textColor: rgba(48, 48, 48))
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

                let retweetedStatusTuple = emoticonString(layout: self, content: rText, fontSize: retweetedTextFontSize, textColor: rgba(48, 48, 48))
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
        let fullTexttuple = searchFullTextIndex(urlTuple.str, content, layout: layout)
        let attrString = fullTexttuple.str
        let attr = NSMutableAttributedString(string: attrString)


        let eleDict = [NSAttributedStringKey.foregroundColor: elementTextColor]
        if fullTexttuple.isChanged {
            layout.addAttributes(attr: eleDict, range: fullTexttuple.value.range)
            attr.setTextHighlight(fullTexttuple.value.range, color: elementTextColor, backgroundColor: elementTextColor.withAlphaComponent(0.4)) { (_, _, _, _) in
                printLog("--- \(attr.string.subString(range: fullTexttuple.value.range))  \(fullTexttuple.value.url)")
            }
        }

        for item in urlTuple.ranges {
            if fullTexttuple.isChanged {
                if item.range.location < fullTexttuple.value.range.location {
                    urlAddAction(item.range, item.url, attr)
                }
            } else {
                urlAddAction(item.range, item.url, attr)
            }
        }

        searchTopics(attr, layout: layout)

        let lineSpace: CGFloat = 5
        var offset = -(1.0/3) * lineSpace - 1.0/3
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = lineSpace

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
        let statusTextSize = (attrString as NSString).boundingRect(with: CGSize(width: width, height: 1000), options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size
        offset = statusTextSize.height > statusSingleLineHeight ? 0 : offset
        attr.addAttributes([NSAttributedStringKey.baselineOffset: offset], range: NSRange(location: 0, length: attrString.count))
        LLEmoticonManager.shared.replaceEmoticon(attr, attrString, font)

        return (attr, CGSize(width: width, height: statusTextSize.height))
    }


    private func urlAddAction(_ range: NSRange, _ url: String, _ attr: NSMutableAttributedString) {
        attr.setTextHighlight(range, color: elementTextColor, backgroundColor: elementTextColor.withAlphaComponent(0.4)) { (_, _, _, _) in
            printLog("--- \(attr.string.subString(range: range))  \(url)")
            self.delegate?.StatusLayoutDidClickUrl?(urlStr: url)
        }
    }

    // 全文
    private func searchFullTextIndex(_ attrString: String, _ content: String , layout: StatusLayout) -> (str: String, value: (range: NSRange, url: String), isChanged: Bool) {
        let pattern = "...全文： "

        guard let rr = attrString.range(of: pattern) else {
            return (attrString, (attrString.fullRange, ""), false)
        }

        let range = NSRange(location: 0, length: rr.upperBound.encodedOffset)
        let changeContent = attrString.subString(range: NSRange(location: 0, length: range.length - 2))
        let fullTextRange = NSRange(location: range.length - pattern.count + 3, length: 2)

        guard let urlrr = content.range(of: pattern) else {
            return (attrString, (attrString.fullRange, ""), false)
        }
        let urlBeforeRange = NSRange(location: 0, length: urlrr.upperBound.encodedOffset)
        let urlRange = NSRange(location: urlBeforeRange.length, length: content.count - urlBeforeRange.length - 1)

        return (changeContent, (fullTextRange, content.subString(range: urlRange)), true)
    }

    private func searchUrls(_ content: String, layout: StatusLayout) -> (str: String, ranges: [(range: NSRange, url: String)], isChange: Bool) {
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

        var rangeList = [(range: NSRange, url: String)]()
        for item in array.enumerated().reversed() {
            let range = item.element.range
            let url = content.subString(range: range)
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
            rangeList.append((NSRange(location: range.location - reduce, length: 4), url))
        }

        return (str,rangeList, true)
    }

    private func searchTopics(_ attrString: NSMutableAttributedString, layout: StatusLayout) {
        let callTopic = "@[\\u4e00-\\u9fa5a-zA-Z0-9_-]{2,30}"
        let talkTopic = "#[^#]+#"
        let pattern = "\(callTopic)|\(talkTopic)"

        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
            return
        }

        let matches = regx.matches(in: attrString.string, options: [], range: NSRange(location: 0, length: attrString.length))

        for m in matches {
            let r = m.range(at: 0)
            layout.addAttributes(attr: [NSAttributedStringKey.foregroundColor: elementTextColor], range: r)
        }
    }
}
