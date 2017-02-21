//
//  LLRefreshControl.swift
//  WeiboSwift
//
//  Created by mac on 17/2/9.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

// 刷新状态切换临界点

// row
//private let RefreshOffset: CGFloat = 60

// JD
private let RefreshOffset: CGFloat = 75

// 刷新状态
// － Normal：       普通状态，什么也不做
// － Pulling：      超过临界点，如果放手，开始刷新
// － WillRefresh：  用户超过临界点，并且放手
enum RefreshState {
    case Normal
    case Pulling
    case WillRefresh
}


class LLRefreshControl: UIControl {

    // 刷新控件的父视图，下拉刷新控件应适用于 UITableView ／ UICollectionView
    private weak var scrollView: UIScrollView?
    
    lazy fileprivate var refreshView: JDRefreshControlView = JDRefreshControlView.refreshView()
    
    init() {
        super.init(frame: CGRect())
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    
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
        
        
        let height = -(sv.contentInset.top + sv.contentOffset.y)
        
        
        
        if height < 0 {
            return
        }
        
        
        refreshView.pullRation = height > RefreshOffset ? 1.0 : height / RefreshOffset
        
        
        // 根据高度设置刷新控件的 frame
        self.frame = CGRect(x: 0, y: -height, width: sv.bounds.width, height: height)
        
        
        // 判断临界点 － 只需要判断一次
        if sv.isDragging {
            if height > RefreshOffset
                && (refreshView.refreshState == .Normal)
            {
                
                refreshView.refreshState = .Pulling
                
            }else if height <= RefreshOffset && refreshView.refreshState == .Pulling {
                
                refreshView.refreshState = .Normal
            }
        }else {
            if refreshView.refreshState == .Pulling {
                
                beginRefreshing()
                
            }
        }
    }
    
    func beginRefreshing() {
        
        
        guard let sv = scrollView else {
            return
        }
        
        // 如果正在刷新，直接返回
        if refreshView.refreshState == .WillRefresh {
            return
        }
        
        
        // 刷新结束之后，将状态修改为 .Normal 才能够继续响应刷新
        refreshView.refreshState = .WillRefresh
        
        // 让整个刷新视图能够显示出来
        // 解决方法：修改表格的contentInset
        var inset = sv.contentInset
        inset.top += RefreshOffset
        sv.contentInset = inset
        
        
        sendActions(for: .valueChanged)
    }
    
    
    func endRefreshing() {
        
        guard let sv = scrollView else {
            return
        }
        
        if refreshView.refreshState != .WillRefresh {
            return
        }
        
        refreshView.refreshState = .Normal
        
        var inset = sv.contentInset
        inset.top -= RefreshOffset
        
        UIView.animate(withDuration: 0.3) {
          sv.contentInset = inset
        }
    }
    
    
    override func removeFromSuperview() {
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        super.removeFromSuperview()
    }
}


extension LLRefreshControl {
    func setupUI() {
    
//        clipsToBounds = true
        
        addSubview(refreshView)
        
        // 自动布局 － 设置 xib 控件的自动布局，需要指定宽高约束
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.width))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.height))
    }
}
