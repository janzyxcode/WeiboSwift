//
//  WBVisitorView.swift
//  WeiboSwift
//
//  Created by mac on 17/1/13.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

class WBVisitorView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func startAnimation() {
        
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * M_PI
        anim.repeatCount = MAXFLOAT
        anim.duration = 15
        
        // 循环播放，动画完成不删除
        anim.isRemovedOnCompletion = false
        // 将动画添加到图层，但控件被销毁，动画也会一起被销毁
        iconView.layer.add(anim
            , forKey: nil)
        
    }
    
    
    var visitorInfo: [String: String]? {
        didSet {
            
            guard let imageName = visitorInfo?["imageName"],
            let mesage = visitorInfo?["message"] else {
                return
            }
            
            tipLabel.text = mesage
            
            if imageName == "" {
                startAnimation()
                return
            }
            
            iconView.image = UIImage(named: imageName)
            
            houseIconView.isHidden = true
            maskIconView.isHidden = true
        }
    }
    
    
    
    
    lazy fileprivate var iconView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    
    lazy var maskIconView: UIImageView = UIImageView(image: UIImage(named:"visitordiscover_feed_mask_smallicon"))
    
    lazy var houseIconView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    lazy var tipLabel: UILabel = { ()->UILabel in
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0;
        return label
    }()
    
    
    lazy var registerButton: UIButton = {()->UIButton in
        let btn = UIButton()
        btn.setTitle("注册", for: .normal)
        btn.setTitleColor(UIColor.orange, for: .normal)
        btn.setTitleColor(UIColor.black, for: .highlighted)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setBackgroundImage(UIImage(named:"common_button_white_disable"), for: .normal)
        return btn
    }()
    
    lazy var loginButton: UIButton = {()->UIButton in
        let btn = UIButton()
        btn.setTitle("登录", for: .normal)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.setTitleColor(UIColor.black, for: .highlighted)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setBackgroundImage(UIImage(named:"common_button_white_disable"), for: .normal)
        return btn
    }()
    
}


extension WBVisitorView {
    
    func setupViews() {
        backgroundColor = UIColor.ColorHex(hex: "ededed")
        
        addSubview(iconView)
        addSubview(maskIconView)
        addSubview(houseIconView)
        addSubview(tipLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        
        // 取消  autoresizing
        for v in subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let margin: CGFloat = 20.0
        
        
        //
        addConstraint(NSLayoutConstraint(item: iconView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: iconView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: -60))
        //
        addConstraint(NSLayoutConstraint(item: houseIconView, attribute: .centerX, relatedBy: .equal, toItem: iconView, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: houseIconView, attribute: .centerY, relatedBy: .equal, toItem: iconView, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        //
        addConstraint(NSLayoutConstraint(item: tipLabel, attribute: .centerX, relatedBy: .equal, toItem: iconView, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: tipLabel, attribute: .top, relatedBy: .equal, toItem: iconView, attribute: .bottom, multiplier: 1.0, constant: margin))
        addConstraint(NSLayoutConstraint(item: tipLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 236))
        
        
        //  因为没有设置按钮的高度，所以切片时 Slicing时设置水平拉伸
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .left, relatedBy: .equal, toItem: tipLabel, attribute: .left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .top, relatedBy: .equal, toItem: tipLabel, attribute: .bottom, multiplier: 1.0, constant: margin))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100))
        
        //  因为没有设置按钮的高度，所以切片时 Slicing时设置水平拉伸
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .right, relatedBy: .equal, toItem: tipLabel, attribute: .right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .top, relatedBy: .equal, toItem: registerButton, attribute: .top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .width, relatedBy: .equal, toItem: registerButton, attribute: .width, multiplier: 1.0, constant: 0))
        
        
        
        // views: 定义 VFL 中的控件名称和实际名称映射关系
        // metrics: 定义 VFL 中（）指定的常数影射关系
        // 如果崩溃看有没有添加到父视图上
        let viewDict = ["maskIconView": maskIconView,
                        "registerButton": registerButton] as [String : UIView]
        let metrics = ["spacing": -20];
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[maskIconView]-0-|", options: [], metrics: nil, views: viewDict))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[maskIconView]-(spacing)-[registerButton]", options: [], metrics: metrics, views: viewDict))
    }
    
    
    
    
    // layout
    
    /*
     苹果原生自动布局介绍
     
     1、自动布局核心公式：
     view1.attr1 = view2.attr2 * multiplier + constant
     
     2、自动布局构造函数
     
     NSLayoutConstraint(item: houseIconView,
     attribute: 约束属性,
     relatedBy: 约束关系,
     toItem: 参照视图,
     attribute: 参照属性,
     multiplier: 乘积,
     constant: 约束数值)
     
     3、如果指定 宽 高 约束
     参照视图设置为 nil
     参照属性选择 .notAnAttribute
     
     
     4、自动布局类函数
     
     NSLayoutConstraint.constraints(withVisualFormat: VLF公式,
     options: ［］,
     metrics: 约束数值字典［String：数值］,
     views: 视图字典［String：子视图］)
     
     5、VFL 可视化格式语言
     
     H    水平方向
     V    垂直方向
     ｜    边界
     []    包含控件的名称字符串，对应关系在 views 字典中定义
     ()    定义控件的宽／高，可以在 metrics 中指定
     
     提示：VLF 通常用于连续参照关系，如果遇到居中对齐，通常直接使用参照
     */
    
}
