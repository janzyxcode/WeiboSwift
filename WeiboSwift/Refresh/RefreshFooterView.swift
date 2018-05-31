//
//  RefreshFooterView.swift
//  Animation
//
//  Created by  user on 2018/1/29.
//  Copyright © 2018年 NG. All rights reserved.
//

import UIKit

enum NGFooterRefreshControlStatus {
    case normal
    case refreshing
    case loadToEnd
}

class RefreshFooterView: UIView {

    var tipL: UILabel = UILabel()
    private var indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    private var leftLine = UIView()
    private var rightLine = UIView()

    private var footerStatus = NGFooterRefreshControlStatus.normal
    private var footerTarget: Any?
    private var footerSelector: Selector?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let tipLWidth: CGFloat = 90
        tipL.frame = CGRect(x: (bounds.width - tipLWidth)*0.5, y: 0, width: tipLWidth, height: bounds.height)

        indicator.center = CGPoint(x: tipL.center.x - tipLWidth * 0.5, y: tipL.center.y)
        leftLine.center = CGPoint(x: tipL.center.x - (tipLWidth + leftLine.bounds.width) * 0.5 - 10, y: tipL.center.y)
        rightLine.center = CGPoint(x: tipL.center.x + (tipLWidth + rightLine.bounds.width) * 0.5 + 10, y: tipL.center.y)
    }

    func observeContentOffset(scrollView: UIScrollView) {
        if scrollView.contentSize.height > 0
            && scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.bounds.height - scrollView.contentOffset.y < 0
            && footerStatus == .normal {
            self.beginRefreshing()
        }
    }

    func observeContentSize(scrollView: UIScrollView) {
        self.frame = CGRect(x: 0, y: scrollView.contentSize.height, width: scrollView.bounds.width, height: scrollView.contentInset.bottom)
    }
}

extension RefreshFooterView {
    func addTarget(_ target: Any?, action: Selector) {
        footerTarget = target
        footerSelector = action
    }

    private func beginRefreshing() {
        if let target = footerTarget,
            let action = footerSelector {
            if (target as AnyObject).responds(to: action) {
                _ = (target as AnyObject).perform(action)
                footerStatus = .refreshing
                loading()
            }
        }
    }

    func endRefreshing() {
        footerStatus = .normal
        waitingLoad()
    }

}

extension RefreshFooterView {

    private func setupViews() {
        tipL.text = "下拉加载更多"
        tipL.font = UIFont.systemFont(ofSize: 14)
        tipL.textColor = UIColor.init(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        tipL.textAlignment = .center
        addSubview(tipL)

        indicator.isHidden = true
        addSubview(indicator)

        leftLine.frame = CGRect(x: 0, y: 0, width: 20, height: 0.5)
        rightLine.frame = leftLine.frame
        leftLine.backgroundColor = UIColor.init(red: 190/255, green: 190/255, blue: 190/255, alpha: 1)
        rightLine.backgroundColor = leftLine.backgroundColor
        addSubview(leftLine)
        addSubview(rightLine)
    }

    private func loading() {
        tipL.isHidden = false
        tipL.text = "加载中..."
        leftLine.isHidden = true
        rightLine.isHidden = true
        indicator.isHidden = false
        indicator.startAnimating()
    }

    private func waitingLoad() {
        tipL.isHidden = false
        tipL.text = "下拉加载更多"
        leftLine.isHidden = false
        rightLine.isHidden = false
        indicator.isHidden = true
        indicator.stopAnimating()
    }

    func loadedEndPage(_ showTip: Bool = false) {
        footerStatus = .loadToEnd

        tipL.isHidden = showTip
        leftLine.isHidden = showTip
        rightLine.isHidden = showTip
        indicator.isHidden = true
        tipL.text = "加载完毕"
        indicator.stopAnimating()
    }
}
