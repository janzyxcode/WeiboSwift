//
//  AppDelegate.swift
//  WeiboSwift
//
//  Created by mac on 17/1/9.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        SingletonData.shared.getLocalUserAccount()
        
        window = UIWindow()
        window?.backgroundColor = UIColor.white
        window?.rootViewController = WBMainViewController()
        window?.makeKeyAndVisible()

        configNaviBar()
        return true
    }
}

private extension AppDelegate {
    func configNaviBar() {
        let nav = UINavigationBar.appearance()
        nav.barTintColor = UIColor.ColorHex(hex: "F6F6F6")
        nav.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        nav.tintColor = UIColor.orange
    }
}
