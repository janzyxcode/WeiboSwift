//
//  LLEmoticonCell.swift
//  KeyboardInput
//
//  Created by mac on 17/2/17.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

/**
 在swift 3中，新增加了一个 fileprivate来显式的表明，这个元素的访问权限为文件内私有。过去的private对应现在的fileprivate。现在的private则是真正的私有，离开了这个类或者结构体的作用域外面就无法访问。
 
 */

@objc protocol LLEmoticonCellDelegate: NSObjectProtocol {
    
    // em： 表情模型／nil 表示删除
    func emoticonCellDidSelectedEmoticon(cell: LLEmoticonCell, em: LLEmoticon?)
}


class LLEmoticonCell: UICollectionViewCell {
    
    weak var delegate: LLEmoticonCellDelegate?
    
    private lazy var tipView = LLEMoticonTipView()
    
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
    
    
    // 当视图从界面上删除，同样会调用次法官法， newWindow == nil
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        guard let w = newWindow else {
            return
        }
        
        
        // 将提示视图添加到窗口上
        // 提示：在iOS 6.0 之前，很多程序员都喜欢被控件往窗口添加
        // 在现在开放，如果有地方，就不要用窗口
        w.addSubview(tipView)
    }

    @objc fileprivate func selectedEmoticonButton(button: UIButton) {
        
        let tag = button.tag
        
        var em:LLEmoticon?
        
        if tag < (emoticons?.count)!{
            em = emoticons?[tag]
        }
        
        delegate?.emoticonCellDidSelectedEmoticon(cell: self, em: em)
    }
    
    
    @objc fileprivate func longGesture(gesture: UILongPressGestureRecognizer) {
        
        let location = gesture.location(in: self)
        
        guard let btn = buttonWithLocation(location: location) else {
            tipView.isHidden = true
            return
        }
        //FXIME:刚进来第一个cell创建的tipView一直显示
        // 处理手势状态
        switch gesture.state {
        case .began, .changed:
            tipView.isHidden = false
            
            // 坐标系的转换 -> 将按钮参照 cell 的坐标系，转换到window的坐标位置
            let center = self.convert(btn.center, to: window)
            
            tipView.center = center
            
            if btn.tag < (emoticons?.count)! {
                tipView.emoticon = emoticons?[btn.tag]
            }
        case .ended:
            tipView.isHidden = true
            selectedEmoticonButton(button: btn)
            
        case .cancelled, .failed:
            tipView.isHidden = true
        default:
            break
        }
    }
    
    private func buttonWithLocation(location: CGPoint)->UIButton? {
        
        for btn in contentView.subviews as! [UIButton] {
            if btn.frame.contains(location)
               && !btn.isHidden {
                return btn
            }
        }
        
        return nil
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
        
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longGesture))
        
        longPress.minimumPressDuration = 0.1
        addGestureRecognizer(longPress)
    }
}
