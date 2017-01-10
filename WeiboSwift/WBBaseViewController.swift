//
//  WBBaseViewController.swift
//  WeiboSwift
//
//  Created by mac on 17/1/10.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

class WBBaseViewController: UIViewController {

    lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 64))
    lazy var navItem = UINavigationItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
    }

    
    override var title: String? {
        didSet {
            navItem.title = title
        }
    }
}


extension WBBaseViewController {
    //FIXME: private为什么报错
    func setUpViews() {
        view.backgroundColor = UIColor.red
        
        view.addSubview(navigationBar)
        navigationBar.items = [navItem]
       // 设置navBar的渲染颜色
        navigationBar.barTintColor = UIColor.ColorHex(hex: "F6F6F6")
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGray]
    }
    
}

