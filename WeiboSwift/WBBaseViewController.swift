//
//  WBBaseViewController.swift
//  WeiboSwift
//
//  Created by mac on 17/1/10.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

class WBBaseViewController: UIViewController {

    var visitorInfoDictionary: [String: String]?

    lazy var navItem = UINavigationItem()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        // 取消自动缩进 - 如果隐藏了导航栏，会缩进 20 个点
//        automaticallyAdjustsScrollViewInsets = false

        if SingletonData.shared.userLogon {
            setupContentViews()
            loadData()
        } else {
            setupVisitorView()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name(WBUserLoginSuccessedNotification), object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        printLog(self)
    }
    
    override var title: String? {
        didSet {
            navItem.title = title
        }
    }
}


private extension WBBaseViewController {

    @objc func loginSuccess() {
        printLog("loginSuccess")
        
        navItem.leftBarButtonItems = nil
        navItem.rightBarButtonItems = nil
        
        // 更新UI => 将访客视图替换为表格视图
        // 需要重新设置view
        // 在访问 view 的 getter 时，如果 view == nil 会调用 loadView -> viewDidLoad
        view = nil
        
        // 注销通知 -> 重新执行viewDidLoad 会再次注册，避免通知被重新注册
        NotificationCenter.default.removeObserver(self)
    }

    func setupVisitorView() {

        guard let visitorDict = visitorInfoDictionary else {
            return
        }

        let visitorView = WBVisitorView(frame: view.bounds);
        visitorView.visitorInfo = visitorDict
        visitorView.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        visitorView.registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        view.addSubview(visitorView)

        navItem.leftBarButtonItems = UIBarButtonItem.fixtedSpace(title: "注册", target: self, action: #selector(register))
        navItem.rightBarButtonItems = UIBarButtonItem.fixtedSpace(title: "登录", target: self, action: #selector(login))
    }


    @objc func login() {
        printLog("login")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
    }

    @objc func register() {
        printLog("register")
    }
}

extension WBBaseViewController {

    @objc func setupContentViews() {

    }

    @objc func loadData() {

    }
}
