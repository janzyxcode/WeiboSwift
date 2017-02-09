//
//  LLRefreshView.swift
//  WeiboSwift
//
//  Created by mac on 17/2/9.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

class LLRefreshView: UIView {

    @IBOutlet weak var tipIcon: UIImageView!
    
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var refreshState: RefreshState = .Normal
    
    class func refreshView()-> LLRefreshView {
        let nib = UINib(nibName: "LLRefreshView", bundle: nil)
        return nib.instantiate(withOwner: nib, options: nil)[0] as! LLRefreshView
        
    }

}
