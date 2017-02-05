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
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .carPlay]) { (success, error) in
                print("autorization:" + (success ? "success" : "failed"))
            }
        }else {
            let notifySettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(notifySettings)
            
        }
        
        print(isNewVersion)
        
        window = UIWindow()
        window?.backgroundColor = UIColor.white
        
        window?.rootViewController = WBMainViewController()
        
        window?.makeKeyAndVisible()
        
        //        loadAppInfo()
        
        return true
    }
}


extension AppDelegate {
    //FIXME:加上 private 就不能访问了
    func loadAppInfo() {
        
        //        DispatchQueue.global().async {
        //
        //            let url = Bundle.main.url(forResource: "main.json", withExtension: nil)
        //            let data = NSData(contentsOf: url!)
        //            let docDict = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        //            let jsonPath = (docDict as NSString).appendingPathComponent("main.json")
        //            data?.write(toFile: jsonPath, atomically: true)
        //            print(jsonPath)
        //            
        //        }
    }
    
    var isNewVersion: Bool {
        
        let currentVerison = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
        
        let libarayPaths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        
        guard let libarayPath = libarayPaths.first else {
            return true
        }
        
        let versionPath = libarayPath + "/version"
        
        let cacheVersion = try? String(contentsOfFile: versionPath, encoding: .utf8)
        
        _ = try? currentVerison.write(toFile: versionPath, atomically: true, encoding: .utf8)
        
        return currentVerison != cacheVersion
    }
    
}

