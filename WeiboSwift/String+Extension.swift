//
//  String+Extension.swift
//  DailySwift
//
//  Created by mac on 17/2/15.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import Foundation

typealias VoidBackBlock = () -> Void

extension String {
    
    // 返回’元组‘
    func ll_href() -> (link: String, text: String)? {
     
        // 常说的正则表达式，就是pattern的写法［匹配方案］
        // 索引：
        // 0: 和匹配方案完全一致的字符串
        // 1： 第一个（）中的内容
        // 2: 第二个（）中的内容
        // .... 索引从左向右顺序递增
        
        // 对于模糊匹配，如果关心的内容，就是用 (.*?) ，然后通过索引可以获取结果
        // 如果不关心的内容，就是 '.*?' ，可以匹配任意的内容
        
        let pattern = "<a href=\"(.*?)\".*?>(.*?)</a>"
        
        
        // 创建正则表达式，如果 pattern 失败，抛出异常
        
        // 进行查找，两种查找方法
        // [只找第一个匹配项／查找多个匹配项]
        
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []), let result = regx.firstMatch(in: self, options: [], range: NSRange(location: 0, length: characters.count))
            else {
            return nil
        }
        
        
        // result 中质油两个重要的方法
        //  result.numberOfRanges -> 查找到的范围数量
        //  result.rangeAt(idx)   ->  指定‘索引’位置的范围
       
        let link = (self as NSString).substring(with: result.range(at: 1))
        let text = (self as NSString).substring(with: result.range(at: 2))
        
        return (link, text)
        
    }

    var deleteSpaccString: String {
        return self.replacingOccurrences(of: " ", with: "")
    }

    var decimalDigitsString: String {
        return self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }

    func subString(start: Int, length: Int = -1) -> String {
        return subString(range: NSRange(location: start, length: length))
    }

    public func substring(from index: Int) -> String {
        if self.count > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[startIndex..<self.endIndex]
            return String(subString)
        } else {
            return self
        }
    }

    public func substring(to index: Int) -> String {
        return subString(start: 0, length: index)
    }

    func subString(range: NSRange) -> String {
        var len = range.length
        if len == -1 {
            len = self.count - range.location
        }
        let st = self.index(startIndex, offsetBy: range.location)
        let en = self.index(st, offsetBy: len)
        return String(self[st ..< en])
    }

    static func textSize(_ text: String?, _ font: UIFont) -> CGSize {
        var tsize = CGSize.zero
        if text != nil && text!.count > 0 {
            tsize = (text! as NSString).size(withAttributes: [NSAttributedStringKey.font: font])
        }
        return tsize
    }

    static func multiLineTextSize(_ text: String?, _ maxSize: CGSize, _ font: UIFont) -> CGSize {
        var tsize = CGSize.zero
        if text != nil && text!.count > 0 {
            tsize = (text! as NSString).boundingRect(with: maxSize,
                                                     options: .usesLineFragmentOrigin,
                                                     attributes: [NSAttributedStringKey.font: font],
                                                     context: nil).size
            (text! as NSString).size(withAttributes: [NSAttributedStringKey.font: font])
        }
        return tsize
    }

    //隐藏手机中间数字
    static func getStarMobile(mobile: String?) -> String {
        if let mobile = mobile {
            if isTelNumber(num: mobile as NSString) == true {//手机号码符合要求
                let startIndex = mobile.index(mobile.startIndex, offsetBy: 3)
                let endIndex = mobile.index(startIndex, offsetBy: 4)
                return mobile.replacingCharacters(in: startIndex..<endIndex, with: "****")
            }
            return mobile
        }
        return ""
    }

  
    static func isTelNumber(num: NSString) -> Bool {

        let mobile = "^1((3[0-9]|4[57]|5[0-35-9]|7[0678]|8[0-9])\\d{8}$)"

        /**

         * 中国移动：China Mobile

         * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705

         */

        let CM = "(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)"

        /**

         * 中国联通：China Unicom

         * 130,131,132,155,156,185,186,145,176,1709

         */

        let CU = "(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)"

        /**

         * 中国电信：China Telecom

         * 133,153,180,181,189,177,1700

         */

        let CT = "(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)"

        let regextestmobile = NSPredicate(format: "SELF MATCHES %@", mobile)

        let regextestcm = NSPredicate(format: "SELF MATCHES %@", CM )

        let regextestcu = NSPredicate(format: "SELF MATCHES %@", CU)

        let regextestct = NSPredicate(format: "SELF MATCHES %@", CT)

        if regextestmobile.evaluate(with: num)

            || regextestcm.evaluate(with: num)

            || regextestct.evaluate(with: num)

            || regextestcu.evaluate(with: num) {
            return true
        } else {
            return false
        }
    }
}

extension String {
    static func moneyShow(_ value: Double) -> String {
        return String(format: "%.2f", value)
    }

    /// 本地化后的字符串
    var localizedString: String {
        return NSLocalizedString(self, comment: "default")
    }

    static public func verifyName(_ str: String?) -> String? {
        if let str = str {
            if str.count >= 2 {
                return str
            }
        }
        return nil
    }

    /// 判断字符串长度是否大于0
    var isEmptyString: Bool {
        var tempStr: String?
        tempStr = self
        guard let str = tempStr else {
            return false
        }
        return str.isEmpty
    }

    /// 如果字符串长度大于0就返回该字符串值，否则返回nil
    var lenLargeThanZeroString: String? {
        return isEmptyString ?  nil : self
    }

    func validateStringInput(inputBlock: VoidBackBlock?, validateBlock: ((String) -> Void)?) {
        if let inputBlock = inputBlock {
            if isEmptyString == true {
                inputBlock()
            }
        }

        if let validateBlock = validateBlock,
            let valueString = lenLargeThanZeroString {
            validateBlock(valueString)
        }
    }
}
