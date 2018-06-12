//
//  ScrollRefresh.swift
//  Animation
//
//  Created by  user on 2018/1/30.
//  Copyright © 2018年 NG. All rights reserved.
//

import Foundation
import UIKit

// header refresh
extension UIScrollView {
    func ngHeaderRefreshAddTarget(_ target: Any?, action: Selector) {
        if ngRefreshHeaderView() != nil || target == nil {
            return
        }
        let header = RefreshHeaderView()
        header.addTarget(target, action: action)
        addSubview(header)

        observeContentOffset {
            header.observeContentOffset(scrollView: self)
        }
    }

    func ngBeginRefreshing() {
        if let headerView = ngRefreshHeaderView() {
            headerView.autoBeginRefresh()
        }
    }

    func ngHeaderEndRefreshing() {
        if let headerView = ngRefreshHeaderView() {
            headerView.endRefreshing()
        }
    }

    func ngRefreshHeaderView() -> RefreshHeaderView? {
        for item in subviews {
            if let headerView = item as? RefreshHeaderView {
                return headerView
            }
        }
        return nil
    }
}

// footer refresh
extension UIScrollView {
    func ngFooterRefreshAddTarget(_ target: Any?, action: Selector) {
        if ngRefreshFooterView() != nil || target == nil {
            return
        }

        var contentInset = self.contentInset
        contentInset.bottom += 45
        self.contentInset = contentInset

        let footer = RefreshFooterView(frame: CGRect(x: 0, y: contentSize.height, width: bounds.width, height: contentInset.bottom))
        footer.addTarget(target, action: action)
        addSubview(footer)

        observeContentOffset {
            footer.observeContentOffset(scrollView: self)
        }
        observeContentSize {
            footer.observeContentSize(scrollView: self)
        }
    }

    func ngFooterEndRefreshing() {
        if let footerView = ngRefreshFooterView() {
            footerView.endRefreshing()
        }
    }

    func ngFooterLoadedEndPage(_ showTip: Bool = false) {
        if let footerView = ngRefreshFooterView() {
            footerView.loadedEndPage(showTip)
        }
    }

    func ngRefreshFooterView() -> RefreshFooterView? {
        for item in subviews {
            if let footerView = item as? RefreshFooterView {
                return footerView
            }
        }
        return nil
    }
}
