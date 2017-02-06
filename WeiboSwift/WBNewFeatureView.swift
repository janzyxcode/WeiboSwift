//
//  WBNewFeatureView.swift
//  WeiboSwift
//
//  Created by mac on 17/2/6.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

class WBNewFeatureView: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBAction func enterStatus(_ sender: UIButton) {
        removeFromSuperview()
    }
    
    
    class func newFeatureView()->WBNewFeatureView {
        let nib = UINib(nibName: "WBNewFeatureView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil).first as! WBNewFeatureView
        v.frame = UIScreen.main.bounds
        return v
    }
    
    override func awakeFromNib() {
        
        backgroundColor = UIColor.clear
        let count = 1
        let rect = UIScreen.main.bounds
        
        
        for i in 0..<count {
            let imageName = "new_feature_\(i + 1)"
            let imgv = UIImageView(image: UIImage(named: imageName))
            imgv.frame = rect.offsetBy(dx: CGFloat(i) * rect.width, dy: 0)
            scrollView .addSubview(imgv)
        }
        
//        scrollView.contentSize = CGSize(width: CGFloat(count + 1) * rect.width, height: rect.height)
//        scrollView.bounces = false
//        scrollView.isPagingEnabled = true
//        scrollView.showsVerticalScrollIndicator = false
//        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.delegate = self
//       
//        pageControl.numberOfPages = count < 2 ? 0 : count
//        
//        button.isHidden = true
    }
}

extension WBNewFeatureView: UIScrollViewDelegate {
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        
        if page == scrollView.subviews.count {
            removeFromSuperview()
        }
        
        button.isHidden = (page != scrollView.subviews.count -  1)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        button.isHidden = true
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
        pageControl.currentPage = page
        pageControl.isHidden = (page == scrollView.subviews.count)
        
    }
}
