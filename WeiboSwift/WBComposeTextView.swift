//
//  WBComposeTextView.swift
//  WeiboSwift
//
//  Created by mac on 17/2/17.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

class WBComposeTextView: UITextView {

    lazy var placehoderLabel = UILabel()
    
    override func awakeFromNib() {
        setupUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func textChanged(){
        placehoderLabel.isHidden = self.hasText
    }
    
    
    
    // 返回 textView 对应的纯文本的字符串（将属性突破转换成文字）
    var emoticonText: String {
        
        guard let attr = attributedText else {
            return ""
        }
        
        
        // 获取属性文本中的图片［附件： Attachment］
        /**
         1、遍历的范围
         2、选项
         3、闭包
         
         */
        
        var result = String()

//        attr.enumerateAttributes(in: NSRange(location: 0, length: attr.length), options: []) { (dict, range, _) in
//
//            // 如果字典中包含 NSAttachment ‘Key’  说明是图片，否则是文本
//            // 下一个目标： 从 attachment 中如果能够获得 chs 就可以了
//            if let attachment = dict["NSAttachment"] as? LLEmotionAttachment {
//                result += attachment.chs ?? ""
//            }else {
//                let subStr = (attr.string as NSString).substring(with: range)
//
//                result += subStr
//            }
//        }

        
        return result
    }
    

    
    
    // 表情键盘专属方法
    func insertEmoticon(em: LLEmoticon?) {
        
        guard let em = em else {
            // 删除文本
            deleteBackward()
            return
        }
        
        if let emoji = em.emoji,let textRange = selectedTextRange {
            replace(textRange, withText: emoji)
            return
        }
        
        // 代码执行到此，都是图片表情
        // 0. 获取表情中的图像属性文本
        // 所有的排版系统中，几乎都有一个共同的特点，插入的字符的显示，跟随前一个字符的属性，但本身没有‘属性’  ,所以导致第二次插入图片后大小会变
        
        let imageText = NSMutableAttributedString(attributedString: em.imageText(font: font!))
        
        imageText.addAttributes([NSAttributedStringKey.font: font!], range: NSRange(location: 0, length: 1))
        
        // 获取当前 textView 属性文本
        let attrStrM = NSMutableAttributedString(attributedString: attributedText)
        
        // 将图像的属性插入到当前的光标位置
        attrStrM.replaceCharacters(in: selectedRange, with: imageText)
        
        // 记录 光标位置
        let range = selectedRange
        
        // 设置文本
        attributedText = attrStrM
        
        // 恢复光标位置，length 是选中字符的长度，插入文本后，应该为0
        selectedRange = NSRange(location: range.location + 1, length: 0)
        
        
        // 让代理执行文本变化方法 －  在需要的时候，通知代理执行协议方法
        delegate?.textViewDidChange?(self)
        
        // 执行当前对象的文本变化方法
        textChanged()
    }

}



private extension WBComposeTextView {
    
    func setupUI() {
        
        /**
         0、注册通知
           － 通知是一对多，如果其他控件监听到当前文本视图的通知，不会影响
           － 如果使用代理，其他控件就无法使用代理监听通知，最后设置的代理对象有效
         
         日常开发中，代理的监听方式是最多的
         
         － 代理发生事件时，直接让代理执行协议方法
            代理效率更高
            直接的方向传值
         
         － 通知是发生事件时，将通知发送给通知中心，通知中心再‘广播’通知
            通知效率相对低一些
            如果层次嵌套的非常深，可以使用通知传值
         */
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: NSNotification.Name.UITextViewTextDidChange, object: self)
        
        
        placehoderLabel.text = "分享新鲜事..."
        placehoderLabel.textColor = UIColor.lightGray
        placehoderLabel.frame.origin = CGPoint(x: 5, y: 8)
        placehoderLabel.font = self.font
        placehoderLabel.sizeToFit()
        addSubview(placehoderLabel)
    }
}
