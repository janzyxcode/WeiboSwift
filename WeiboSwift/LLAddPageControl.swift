//
//  LLAddPageControl.swift
//  WeiboSwift
//
//  Created by mac on 17/2/14.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit


// 刷新状态切换临界点
private var BottomScrollOffset: CGFloat = 0

// 刷新状态
// － Normal：       普通状态，什么也不做
// － Pulling：      超过临界点，如果放手，开始刷新
// － WillRefresh：  用户超过临界点，并且放手
enum FooterAddState {
    case FooterAddNormal
    //    case FooterAddPulling
    case FooterAddWillRefresh
}


class LLAddPageControl: UIControl {
    
    // 刷新控件的父视图，下拉刷新控件应适用于 UITableView ／ UICollectionView
    private weak var scrollView: UIScrollView?
    
    
    private lazy var addPageView: LLAddPageControlView = {()->LLAddPageControlView in
        let v = LLAddPageControlView.addPageView()
        
        self.addSubview(v)
        BottomScrollOffset = v.bounds.height
        self.backgroundColor = UIColor.red
        // 自动布局 － 设置 xib 控件的自动布局，需要指定宽高约束
        v.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraint(NSLayoutConstraint(item: v,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        self.addConstraint(NSLayoutConstraint(item: v,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 0))
        self.addConstraint(NSLayoutConstraint(item: v,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: v.bounds.width))
        self.addConstraint(NSLayoutConstraint(item: v,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: v.bounds.height))
        
        return v
    }()
    
 
    
    /**
     willMove： addSubview 方法会调用
     － 当添加到父视图的时候，newSuperview 是父视图
     － 当父视图被移除，newSuperview 是 nil
     */
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        
        backgroundColor = newSuperview?.backgroundColor
        
        guard let sv = newSuperview as? UIScrollView else {
            return
        }
        
        scrollView = sv
        
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    
    // 所有 KVO 方法会统一调用此方法
    // 在程序中，通常只监听某一个对象的某几个属性，如果属性太多，方法会很乱
    // 观察者模式，在不需要的时候，都需要释放
    // － 通知中心：如果不释放，什么液不会发生，但是会有内存泄漏，会有多次注册的可能
    // － KVO：如果不释放，会崩溃
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        
        guard let sv = scrollView else {
            return
        }
        
        
        //FIXME:在多次下拉会出现转菊花不隐藏的情况
        let scrollToBottom = sv.contentOffset.y + sv.bounds.height - sv.contentInset.bottom < sv.contentSize.height
        
        
        if scrollToBottom == true {
            return
        }
        

        // 根据高度设置刷新控件的 frame
        self.frame = CGRect(x: 0, y: sv.contentSize.height, width: sv.bounds.width, height: BottomScrollOffset)
        
        
        // 判断临界点 － 只需要判断一次
        if sv.isDragging {
            beginRefreshing()
        }
    }
    
    func beginRefreshing() {
        
        
        guard let sv = scrollView else {
            return
        }
        
        let state = addPageView.addPageState
        
        
        if state == .FooterAddWillRefresh {
            return
        }
        
        printLog(addPageView.addPageState)
        // 刷新结束之后，将状态修改为 .Normal 才能够继续响应刷新
        addPageView.addPageState = .FooterAddWillRefresh
        
        // 让整个刷新视图能够显示出来
        // 解决方法：修改表格的contentInset
        var inset = sv.contentInset
        inset.bottom += BottomScrollOffset
        sv.contentInset = inset
        
        
        sendActions(for: .valueChanged)
    }
    
    
    func endRefreshing() {
        
        guard let sv = scrollView else {
            return
        }
        
        if addPageView.addPageState != .FooterAddWillRefresh {
            return
        }
        
        addPageView.addPageState = .FooterAddNormal
        
        var inset = sv.contentInset
        inset.bottom -= BottomScrollOffset
        
        UIView.animate(withDuration: 0.25) {
            sv.contentInset = inset
        }
    }
    
    
    override func removeFromSuperview() {
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        super.removeFromSuperview()
    }
    
}



