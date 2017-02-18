//
//  LLEmoticonCell.swift
//  KeyboardInput
//
//  Created by mac on 17/2/17.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit


@objc protocol LLEmoticonCellDelegate: NSObjectProtocol {
    
    // em： 表情模型／nil 表示删除
    func emoticonCellDidSelectedEmoticon(cell: LLEmoticonCell, em: LLEmoticon?)
}


class LLEmoticonCell: UICollectionViewCell {
    
    weak var delegate: LLEmoticonCellDelegate?
    
    var emoticons: [LLEmoticon]? {
        didSet {
            
            for v in contentView.subviews {
                v.isHidden = true
            }
            
            contentView.subviews.last?.isHidden = false
            
            for (i, em) in (emoticons ?? []).enumerated() {
                if let btn = contentView.subviews[i] as? UIButton {
                    
                    btn.setImage(em.image, for: [])
                    
                    // 设置 emoji 的字符串
                    btn.setTitle(em.emoji, for: [])
                    
                    btn.isHidden = false
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    @objc func selectedEmoticonButton(button: UIButton) {
        
        let tag = button.tag
        
        var em:LLEmoticon?
        
        if tag < (emoticons?.count)!{
            em = emoticons?[tag]
        }
        
        delegate?.emoticonCellDidSelectedEmoticon(cell: self, em: em)
    }
    
}

private extension LLEmoticonCell {
    
    func setupUI() {
        
        let rowCount = 3
        let colCount = 7
        
        let leftMargin: CGFloat = 8
        let bottomMargin: CGFloat = 16
        
        let w = (bounds.width - 2 * leftMargin) / CGFloat(colCount)
        let h = (bounds.height - bottomMargin) / CGFloat(rowCount)
        
        for i in 0..<21 {
            
            let row = i / colCount
            let col = i % colCount
            
            let btn = UIButton()
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            btn.tag = i
            btn.frame = CGRect(x: leftMargin + CGFloat(col) * w,
                               y: CGFloat(row) * h,
                               width: w,
                               height: h)
            
            contentView.addSubview(btn)
        
            btn.addTarget(self, action: #selector(selectedEmoticonButton(button:)), for: .touchUpInside)
        }
        
        let removeBtn = contentView.subviews.last as! UIButton
        
        let image = UIImage(named: "compose_emotion_delete", in: LLEmoticonManager.shared.bundle, compatibleWith: nil)
        removeBtn.setImage(image, for: [])
        
        
    }
}
