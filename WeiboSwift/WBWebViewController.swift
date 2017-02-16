//
//  WBWebViewController.swift
//  WeiboSwift
//
//  Created by mac on 17/2/16.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

class WBWebViewController: WBBaseViewController {

    var urlString: String? {
        didSet {
            guard let urlString = urlString,
                  let url = URL(string: urlString)
            else {
                return
            }
            
            webView.loadRequest(URLRequest(url: url))
        }
    }
    
    lazy var webView = UIWebView(frame: UIScreen.main.bounds)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
}


extension WBWebViewController {
    
    override func setupTableView() {
        
        navItem.title = "网页"
        
        view.insertSubview(webView, belowSubview: navigationBar)
        webView.backgroundColor = UIColor.white
        webView.scrollView.contentInset.top = navigationBar.bounds.height
    }
}
