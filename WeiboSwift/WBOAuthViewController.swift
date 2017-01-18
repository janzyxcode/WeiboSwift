//
//  WBOAuthViewController.swift
//  WeiboSwift
//
//  Created by mac on 17/1/18.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

class WBOAuthViewController: UIViewController {

    private lazy var webView = UIWebView()
    
    override func loadView() {
        view = webView
        
        view.backgroundColor = UIColor.orange
        
        title = "登录新浪微博"
        
        navigationItem.leftBarButtonItems = UIBarButtonItem.fixtedSpace(title: "返回", target: self, action: #selector(close))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
}
