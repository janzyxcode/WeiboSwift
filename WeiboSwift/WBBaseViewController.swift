//
//  WBBaseViewController.swift
//  WeiboSwift
//
//  Created by mac on 17/1/10.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit


// 面试题：OC 中支持多继承吗？不支持，使用协议替代


class WBBaseViewController: UIViewController {

    // 用户登录标记
    var userLogin = false
    
    var tableView: UITableView?
    
    var visitorInfoDictionary: [String: String]?
    
    var refreshControl: UIRefreshControl?
    
    var isPullup = false
    
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


// Swift中，利用 extension 可以把 函数 按照功能分类管理，便于阅读和维护
// 1. extension 中不能有属性
// 1. extension 中不能重写父类方法！重写父类方法，是子类的职责，扩展是对类的扩展


extension WBBaseViewController {
    
    func setUpViews() {
        
        view.backgroundColor = UIColor.red
        
        // 取消自动缩进 - 如果隐藏了导航栏，会缩进 20 个点
        automaticallyAdjustsScrollViewInsets = false
        
        setupNavigationBar()
        
        userLogin ?  setupTableView() : setupVisitorView()
        
    }
    
    func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.insertSubview(tableView!, belowSubview: navigationBar)
        tableView?.delegate = self
        tableView?.dataSource = self
        
        tableView?.contentInset = UIEdgeInsetsMake(navigationBar.bounds.height, 0, tabBarController?.tabBar.bounds.height ?? 49, 0)
        
        
        refreshControl = UIRefreshControl()
        tableView?.addSubview(refreshControl!)
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    
    
    func setupVisitorView() {
        let visitorView = WBVisitorView(frame: view.bounds);
        
        view.insertSubview(visitorView, belowSubview: navigationBar)
        
        visitorView.visitorInfo = visitorInfoDictionary
        
    }
    
    
    //FIXME: private为什么报错
    func setupNavigationBar() {
        
        
        view.addSubview(navigationBar)
        navigationBar.items = [navItem]
       // 设置navBar的渲染颜色
        navigationBar.barTintColor = UIColor.ColorHex(hex: "F6F6F6")
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGray]
    }
    
    
    // 加载数据 － 具体的实现由子类负责
    @objc func loadData() {
      
        // 如果子类不实现任何方法， 默认关闭
        refreshControl?.endRefreshing()
        
    }
}


extension WBBaseViewController:UITableViewDelegate,UITableViewDataSource {
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    // 基类只是准备方法，子类负责具体的实现，子类的数据源方法不需要 super
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 只是保证没有语法错误
        return UITableViewCell()
    }
    
    // 在显示最后一行的时候，做上拉刷新
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
       //  判断 indexPath 是否是最后一行
        let row = indexPath.row
        
        let section = tableView.numberOfSections - 1
        
        if row < 0 || section < 0 {
            return
        }
        
        let count = tableView.numberOfRows(inSection: section)
        
        
        // 如果是最后一行，同时没有开始上拉刷新
        if row == (count - 1)
           && !isPullup {
            
            isPullup = true
            loadData()
            
        }
        
        
    }
}

