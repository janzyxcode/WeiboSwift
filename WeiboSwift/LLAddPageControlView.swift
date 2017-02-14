//
//  LLAddPageControlView.swift
//  WeiboSwift
//
//  Created by mac on 17/2/14.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

class LLAddPageControlView: UIView {
    
    var addPageState: FooterAddState = .FooterAddNormal {
        didSet {
            switch addPageState {
            case .FooterAddNormal:
                indicator.stopAnimating()
            case .FooterAddWillRefresh:
                indicator.startAnimating()
            }
        }
    }
    
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    
    class func addPageView()-> LLAddPageControlView {
        let nib = UINib(nibName: "LLAddPageControlView", bundle: nil)
        return nib.instantiate(withOwner: nib, options: nil)[0] as! LLAddPageControlView
    }
    
}
