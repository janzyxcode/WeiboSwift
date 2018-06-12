//
//  RefreshHeaderView.swift
//  Animation
//
//  Created by liaonaigang on 2018/1/25.
//  Copyright © 2018年 NG. All rights reserved.
//

import UIKit

let NGHeaderRefreshOffset: CGFloat = 60

enum NGHeaderRefreshState {
    case normal
    case pulling
    case willRefresh
}

class RefreshHeaderView: UIView {

    private var refreshView = RefreshView.loadFromNib()
    private var headerTarget: Any?
    private var headerSelector: Selector?
    /// 开始加载的时间，用来计算视图加载时间不能低于某个时间戳
    private lazy var startLoadDate = Date()
    private var isAuto = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(refreshView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func observeContentOffset(scrollView: UIScrollView) {
        var height = -(scrollView.contentInset.top + scrollView.contentOffset.y)

        if #available(iOS 11.0, *) {
            height = -(scrollView.adjustedContentInset.top + scrollView.contentOffset.y)
        }

        if height < 0 {
            return
        }

        if scrollView.isDragging || isAuto {
            if height > NGHeaderRefreshOffset && (refreshView.refreshState == .normal) {
                refreshView.refreshState = .pulling
            } else if height <= NGHeaderRefreshOffset && refreshView.refreshState == .pulling && isAuto != true {
                refreshView.refreshState = .normal
            }
        } else {
            if refreshView.refreshState == .pulling {
                beginRefreshing()
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let superv = superview as? UIScrollView else {
            return
        }
        frame = CGRect(x: 0, y: -NGHeaderRefreshOffset, width: superv.bounds.width, height: NGHeaderRefreshOffset)
        backgroundColor = superv.backgroundColor
        refreshView.backgroundColor = backgroundColor
        refreshView.frame = bounds
    }
}

extension RefreshHeaderView {
    func addTarget(_ target: Any?, action: Selector) {
        headerTarget = target
        headerSelector = action
    }

    func autoBeginRefresh() {
        guard let scrollView = superview as? UIScrollView else {
            return
        }

        let off = 5.cgFloatValue
        var offpoint = scrollView.contentOffset
        offpoint.y = -scrollView.contentInset.top - NGHeaderRefreshOffset - off

        if #available(iOS 11.0, *) {
            offpoint.y = -scrollView.adjustedContentInset.top - NGHeaderRefreshOffset - off
        }

        scrollView.isUserInteractionEnabled = false
        isAuto = true
        UIView.animate(withDuration: 0.3, animations: {
            scrollView.contentOffset = offpoint
        }, completion: { (_) in
            scrollView.isUserInteractionEnabled = true
            self.isAuto = false
            offpoint.y += off
            scrollView.contentOffset = offpoint
        })

    }

    private func beginRefreshing() {
        guard let scrollView = superview as? UIScrollView else {
            return
        }

        if refreshView.refreshState == .willRefresh {
            return
        }
        startLoadDate = Date()
        refreshView.refreshState = .willRefresh

        var inset = scrollView.contentInset
        inset.top += NGHeaderRefreshOffset
        scrollView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, animations: {
            scrollView.contentInset = inset
        }, completion: { _ in
            scrollView.isUserInteractionEnabled = true
        })

        if let target = headerTarget,
            let action = headerSelector {
            if (target as AnyObject).responds(to: action) {
                _ = (target as AnyObject).perform(action)
            }
        }
    }

    func endRefreshing() {
        guard let scrollView = superview as? UIScrollView else {
            return
        }

        if refreshView.refreshState != .willRefresh {
            return
        }

        let date = Date()
        let timeinterval = date.timeIntervalSince(startLoadDate)

        // 0.3保证最少菊花能转的时间
        let anInterval = 0.3
        var interval = 0.0
        if timeinterval < anInterval {
            interval = anInterval - timeinterval
        }

        scrollView.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            var inset = scrollView.contentInset
            inset.top -= NGHeaderRefreshOffset

            UIView.animate(withDuration: 0.3, animations: {
                scrollView.contentInset = inset
                scrollView.isUserInteractionEnabled = true
                self.refreshView.refreshState = .normal
                self.refreshView.isHidden = true
            }, completion: { (_) in
                self.refreshView.isHidden = false
            })
        }

    }

}
