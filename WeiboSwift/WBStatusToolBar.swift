//
//  WBStatusToolBar.swift
//  WeiboSwift
//
//  Created by mac on 17/2/7.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

class WBStatusToolBar: UIView {

    var viewModel: WBStatusViewModel? {
        didSet {
            retweetedButton.setTitle(viewModel?.retweetedStr, for: [])
            commentButton.setTitle(viewModel?.commentStr, for: [])
            likeButton.setTitle(viewModel?.likeStr, for: [])
        }
    }
    
    
    @IBOutlet weak var retweetedButton:UIButton!

    @IBOutlet weak var commentButton:UIButton!
    
    @IBOutlet weak var likeButton:UIButton!
}
