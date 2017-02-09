//
//  AppDelegate.swift
//  WeiboSwift
//
//  Created by mac on 17/1/9.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit
import UserNotifications
import SVProgressHUD
import AFNetworking
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setupAdditions()
        
        window = UIWindow()
        window?.backgroundColor = UIColor.white
        
        window?.rootViewController = WBMainViewController()
        
        window?.makeKeyAndVisible()
        
        return true
    }
}



extension AppDelegate {
    
    func setupAdditions() {
        // 设置 SVP 最小解除时间
        
//        SVProgressHUD.setMinimumDismissTimeInterval(1)
        
        // 设置网络加载指示器
        AFNetworkActivityIndicatorManager.shared().isEnabled = true
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .carPlay]) { (success, error) in
                
            }
        }else {
            let notifySettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(notifySettings)
            
        }
    }
}



