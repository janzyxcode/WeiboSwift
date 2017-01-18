//
//  UIScrollView+Extension.swift
//  WeiboSwift
//
//  Created by mac on 17/1/18.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    func scrollToTop() {
        var off = self.contentOffset
        off.y = 0 - self.contentInset.top
        self.setContentOffset(off, animated: true)
    }
    
    func scrollToBottom() {
        var off = self.contentOffset
        off.y = self.contentSize.height - self.bounds.height + self.contentInset.bottom
        self.setContentOffset(off, animated: true)
    }
    
    func scrollToLeft() {
        var off = self.contentOffset
        off.x = 0 - self.contentInset.left
        self.setContentOffset(off, animated: true)
    }
    
    func scrollToRight() {
        var off = self.contentOffset
        off.x = self.contentSize.width - self.bounds.width + self.contentInset.right
        self.setContentOffset(off, animated: true)
    }
}
