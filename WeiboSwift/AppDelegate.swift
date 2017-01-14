//
//  AppDelegate.swift
//  WeiboSwift
//
//  Created by mac on 17/1/9.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
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
    
}

