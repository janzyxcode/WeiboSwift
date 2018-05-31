//
//  UIScrollView+Extensions.swift
//  ECWallet
//
//  Created by  user on 2018/2/1.
//  Copyright © 2018年 ECW. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    func scrollToTop(_ animated: Bool = true) {
        var off = contentOffset
        off.y = 0 - contentInset.top
        setContentOffset(off, animated: animated)
    }

    func scrollToLeft(_ animated: Bool = true) {
        var off = contentOffset
        off.x = 0 - contentInset.left
        setContentOffset(off, animated: animated)
    }

    func scrollToBottom(_ animated: Bool = true) {
        var off = contentOffset
        off.y = contentSize.height - bounds.height + contentInset.bottom
        setContentOffset(off, animated: animated)
    }

    func scrollToRight(_ animated: Bool = true, _ offset: CGFloat = 0) {
        var off = contentOffset
        off.x = contentSize.width - bounds.width + contentInset.right + offset
        setContentOffset(off, animated: animated)
    }

    /// UIViewController的automaticallyAdjustsScrollViewInsets属性已经不再使用,我们需要使用UIScrollView的 contentInsetAdjustmentBehavior 属性来替代它.
    func neverAdjustsScrollViewInsets() {
        if #available(iOS 11.0, *) {
            // The behavior for determining the adjusted content offsets
            contentInsetAdjustmentBehavior = .never
        }
//        else {
//            automaticallyAdjustsScrollViewInsets = false
//        }
    }
}

/// 键值观察器类，使用UIView是为了持有，所以在使用该功能时，在ScrollView删除子试图需要注意
private class KeyValueObserContentView: UIView {
    public var keyValueObservations = [NSKeyValueObservation]()
    deinit {
        for item in keyValueObservations {
            item.invalidate()
        }
        keyValueObservations.removeAll()
    }
}

extension UIScrollView {

    /// UIScrollView偏移观察
    ///
    /// - Parameter closure: 在偏移中所做的操作
    func observeContentOffset(_ closure: @escaping () -> Void) {
        let contentView = getContentView()
        addSubview(contentView)
        let keyValueObservation = observe(\.contentOffset, options: [.new, .old]) {_, _ in
            closure()
        }
        contentView.keyValueObservations.append(keyValueObservation)
    }

    func observeContentSize(_ closure: @escaping () -> Void) {
        let contentView = getContentView()
        addSubview(contentView)
        let keyValueObservation = observe(\.contentSize, options: [.new, .old]) {_, _ in
            closure()
            //            print(change.newValue)
        }
        contentView.keyValueObservations.append(keyValueObservation)
    }

    private func getContentView() -> KeyValueObserContentView {
        for item in subviews {
            if let view = item as? KeyValueObserContentView {
                return view
            }
        }
        return KeyValueObserContentView()
    }
}
