//
//  WBDemoViewController.swift
//  WeiboSwift
//
//  Created by mac on 17/1/10.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

class WBDemoViewController: WBBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
        view.backgroundColor = UIColor.blue
        title = "title" + "\(navigationController?.childViewControllers.count)"
        
        
    }
    
    @objc func showNext() {
        let vc = WBDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
}


extension WBDemoViewController {
    
    override func setUpViews() {
        super.setUpViews()

        
        navItem.rightBarButtonItem = UIBarButtonItem(title: "下一个", target: self, action: #selector(showNext))
    }
}

