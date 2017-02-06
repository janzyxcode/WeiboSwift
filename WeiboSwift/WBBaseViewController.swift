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
    var userLogin = true
    
    var tableView: UITableView?
    
    var visitorInfoDictionary: [String: String]?
    
    var refreshControl: UIRefreshControl?
    
    var isPullup = false
    
    lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 64))
    lazy var navItem = UINavigationItem()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
        
        WBNetworkManager.shared.userLogon ? loadData() : ()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name(WBUserLoginSuccessedNotification), object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        print(self)
    }
    
    override var title: String? {
        didSet {
            navItem.title = title
        }
    }
    
    // 加载数据 － 具体的实现由子类负责
    func loadData() {
        // 如果子类不实现任何方法， 默认关闭
        refreshControl?.endRefreshing()
    }
    
}


extension WBBaseViewController {
    //FIXME:private
    @objc func loginSuccess() {
        print("loginSuccess")
        
        navItem.leftBarButtonItems = nil
        navItem.rightBarButtonItems = nil
        
        // 更新UI => 将访客视图替换为表格视图
        // 需要重新设置view
        // 在访问 view 的 getter 时，如果 view == nil 会调用 loadView -> viewDidLoad
        view = nil
        
        // 注销通知 -> 重新执行viewDidLoad 会再次注册，避免通知被重新注册
        NotificationCenter.default.removeObserver(self)
    }
    
    //FIXME: 使用 private 其他 extension 就不能访问
    @objc func login() {
        print("login")
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
    }
    
    @objc func register() {
        print("register")
    }
}




// Swift中，利用 extension 可以把 函数 按照功能分类管理，便于阅读和维护
// 1. extension 中不能有属性
// 1. extension 中不能重写父类方法！重写父类方法，是子类的职责，扩展是对类的扩展

extension WBBaseViewController {
    
    func setUpViews() {
        
        view.backgroundColor = UIColor.white
        
        // 取消自动缩进 - 如果隐藏了导航栏，会缩进 20 个点
        automaticallyAdjustsScrollViewInsets = false
        
        setupNavigationBar()
        
        (WBNetworkManager.shared.userAccount.access_token != nil) ?  setupTableView() : setupVisitorView()
        
    }
    
    func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.insertSubview(tableView!, belowSubview: navigationBar)
        tableView?.delegate = self
        tableView?.dataSource = self
        
        tableView?.contentInset = UIEdgeInsetsMake(navigationBar.bounds.height, 0, tabBarController?.tabBar.bounds.height ?? 49, 0)
        
        // 修改指示器的缩进
        tableView?.scrollIndicatorInsets = tableView!.contentInset
        
        refreshControl = UIRefreshControl()
        tableView?.addSubview(refreshControl!)
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    
    
    func setupVisitorView() {
        
        guard let visitorDict = visitorInfoDictionary else {
            return
        }
        
        let visitorView = WBVisitorView(frame: view.bounds);
        view.insertSubview(visitorView, belowSubview: navigationBar)
        visitorView.visitorInfo = visitorDict
     
        
        // 使用代理 传递消息是为了在控制器和视图之间解耦，让视图能够被多个控制器服用， 例如 UITableView
        // 但是，如果视图仅仅只是为了封装代码，而从控制器中剥离出来的，并且能够确定该视图不会被其他控制器引用，则可以直接通过 addTarget 的方式为该视图中的按钮添加监听方法
        // 这样做的代价是耦合度高，控制器和视图绑定在一起，但是会省略部分冗余代码
        visitorView.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        visitorView.registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        
        
        
        navItem.leftBarButtonItems = UIBarButtonItem.fixtedSpace(title: "注册", target: self, action: #selector(register))
        navItem.rightBarButtonItems = UIBarButtonItem.fixtedSpace(title: "登录", target: self, action: #selector(login))
    }
    
    
    //FIXME: private为什么报错
    func setupNavigationBar() {
        
        view.addSubview(navigationBar)
        navigationBar.items = [navItem]
       // 设置navBar的渲染颜色
        navigationBar.barTintColor = UIColor.ColorHex(hex: "F6F6F6")
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGray]
        navigationBar.tintColor = UIColor.orange
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

