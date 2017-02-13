//
//  WBComposeTypeView.swift
//  WeiboSwift
//
//  Created by mac on 17/2/10.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit
import pop


private let buttonsInfo = [["imageName": "tabbar_compose_idea", "title": "文字", "clsName": "WBCompViewController"],
                           ["imageName": "tabbar_compose_photo", "title": "照片／视频"],
                           ["imageName": "tabbar_compose_weibo", "title": "长微博"],
                           ["imageName": "tabbar_compose_lbs", "title": "签到"],
                           ["imageName": "tabbar_compose_review", "title": "点评"],
                           ["imageName": "tabbar_compose_more", "title": "更多", "actionName": "clickMore"],
                           ["imageName": "tabbar_compose_friend", "title": "好友圈"],
                           ["imageName": "tabbar_compose_wbcamera", "title": "微博相机"],
                           ["imageName": "tabbar_compose_music", "title": "音乐"],
                           ["imageName": "tabbar_compose_shooting", "title": "拍摄"]]


class WBComposeTypeView: UIView {
    
    private var completionBlock: ((_ clsName: String?)->())?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var returnBtn: UIButton!
    
    @IBOutlet weak var returnButtonCenterXCons: NSLayoutConstraint!
    @IBOutlet weak var closeButtonCenterXCons: NSLayoutConstraint!
    
    
    
    class func composeTypeView() -> WBComposeTypeView {
        let nib = UINib(nibName: "WBComposeView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WBComposeTypeView
        
        // XIB 默认 600*600
        v.frame = UIScreen.main.bounds
        
        //        v.setupUI()
        
        return v
    }
    
    
    func show(completion: @escaping (_ clsName: String?)->()) {
        
        completionBlock = completion
        
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        vc.view.addSubview(self)
        
        showCurrentView()
    }
    
    
    override func awakeFromNib() {
        setupUI()
    }
    
    @IBAction func clickButton() {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        closeButtonCenterXCons.constant = 0
        returnButtonCenterXCons.constant = 0
        
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutIfNeeded()
            self.returnBtn.alpha = 0
        }) { (_) in
            self.returnBtn.isHidden = true
            self.returnBtn.alpha = 1
        }
    }
    
    
    @objc func clickBtn(selectedButton: WBComposeTypebutton) {
        
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let v = scrollView.subviews[page]
        
        for (i, btn) in v.subviews.enumerated() {
            let anim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
            let scale = (btn == selectedButton) ? 2 : 0.2
            anim.toValue = NSValue(cgPoint: CGPoint(x: scale, y: scale))
            anim.duration = 0.5
            btn.pop_add(anim, forKey: nil)
            
            
            let alphaAnim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            alphaAnim.toValue = 0.2
            alphaAnim.duration = 0.5
            btn.pop_add(alphaAnim, forKey: nil)
            
            if i == 0 {
                alphaAnim.completionBlock = { _, _ in
                                        self.completionBlock!(selectedButton.clsName)
                }
            }
            
        }
    }
    
    @objc private func clickMore() {
        
        let offset = CGPoint(x: scrollView.bounds.width, y: 0)
        scrollView.setContentOffset(offset, animated: true)
        
        returnBtn.isHidden = false
        
        let margin = scrollView.bounds.width / 6
        
        closeButtonCenterXCons.constant += margin
        returnButtonCenterXCons.constant -= margin
        
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
        
        
    }
    
    @IBAction func close(_ sender: UIButton) {
        hideButtons()
    }
    
    
    
    
    
}







private extension WBComposeTypeView {
    
    func showCurrentView () {
        
        let anim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim.fromValue = 0
        anim.toValue = 1
        anim.duration = 0.5
        pop_add(anim, forKey: nil)
        
        showButtons()
    }
    
    private func showButtons() {
        
        let v = scrollView.subviews[0]
        for (i, btn) in v.subviews.enumerated() {
            
            let  anim: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            anim.fromValue = btn.center.y + 300
            anim.toValue = btn.center.y
            anim.springBounciness = 8
            anim.springSpeed = 8
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(i) * 0.025
            btn.pop_add(anim, forKey: nil)
        }
    }
}


private extension WBComposeTypeView {
    
    func hideButtons() {
        
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let v = scrollView.subviews[page]
        
        for (i, btn) in v.subviews.enumerated().reversed() {
            
            let anim: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            anim.fromValue = btn.center.y
            anim.toValue = btn.center.y + 350
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(v.subviews.count - i) * 0.025
            btn.layer.pop_add(anim, forKey: nil)
            
            if i == 0 {
                anim.completionBlock = { _, _ in
                    self.hideCurrentView()
                }
            }
        }
    }
    
    
    private func hideCurrentView() {
        
        let anim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim.fromValue =  1
        anim.toValue = 0
        anim.duration = 0.25
        pop_add(anim, forKey: nil)
        anim.completionBlock = { _, _ in
            self.removeFromSuperview()
        }
        
    }
    
}


private extension WBComposeTypeView {
    func setupUI() {
        
        layoutIfNeeded()
        
        let rect = scrollView.bounds
        
        let width = UIScreen.main.bounds.width
        
        for i in 0..<2 {
            let v = UIView(frame: rect.offsetBy(dx: CGFloat(i) * width, dy: 0))
            addButtons(v: v, idx: i * 6)
            scrollView.addSubview(v)
            
        }
        
        
        scrollView.contentSize = CGSize(width: 2 * width, height: 0)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.isScrollEnabled = false
        
    }
    
    func addButtons(v: UIView, idx: Int) {
        
        let count = 6
        
        for i in idx..<(idx + count) {
            
            if i >= buttonsInfo.count {
                continue
            }
            
            let dict = buttonsInfo[i]
            
            guard let imageName = dict["imageName"], let title = dict["title"] else {
                continue
            }
            
            let btn = WBComposeTypebutton.composeTypeButton(imageName: imageName, title: title)
            v.addSubview(btn)
            
            if let actionName = dict["actionName"] {
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            }else {
                btn.addTarget(self, action: #selector(clickBtn(selectedButton:)), for: .touchUpInside)
            }

            btn.clsName = dict["clsName"]
        }
        
        var btnSize = CGSize(width: 100, height: 100)
        var margin = (v.bounds.width - 3 * btnSize.width ) / 4
        
        if UIScreen.main.bounds.width < (btnSize.width * 3 + margin * 4) {
            margin = 10
            let width = (UIScreen.main.bounds.width - 4 * margin) / 3
            btnSize = CGSize(width: width, height: width)
            
        }

        for (i, btn) in v.subviews.enumerated() {
            
            let y: CGFloat = (i > 2) ? (v.bounds.height - btnSize.height) : 0
            let col = i % 3
            let x = CGFloat(col + 1) * margin + CGFloat(col) * btnSize.width
            
            btn.frame = CGRect(x: x, y: y, width: btnSize.width, height: btnSize.height)
            
        }
    }
}
