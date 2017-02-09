//
//  WBNetworkManager.swift
//  WeiboSwift
//
//  Created by mac on 17/1/16.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit
import AFNetworking

// Swift 的枚举支持任意数据类型
//  switch / enum 在OC 中都只是支持整数
enum WBHTTPMethod {
    case GET
    case POST
}


class WBNetworkManager: AFHTTPSessionManager {
    
    //FIXME:单例对网络的好处
    
    // 静态区／常量／闭包
    // 第一次访问时，执行闭包，并且将结果保存在 shared 常量中
    
    static let shared : WBNetworkManager = {
      
        let instance = WBNetworkManager()
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return instance
        
    }()
    
    lazy var userAccount = WBUserAccount()
    
    var userLogon: Bool {
        return userAccount.access_token != nil
    }
    
    
    /// 专门负责拼接 token 的网络请求方法
    func tokenRequest(method: WBHTTPMethod = .GET, URLString: String, parameters: [String: AnyObject]?, completion: @escaping (_ json: AnyObject?, _ isSuccess: Bool)->()) {
        
        guard let token = userAccount.access_token else {
            
            NotificationCenter.default.post(name: NSNotification.Name(WBUserShouldLoginNotification), object: nil)
            
            completion(nil, false)
            return
        }
        
        var parameters = parameters
        
        if parameters == nil {
            parameters = [String: AnyObject]()
        }
        
        parameters!["access_token"] = token as AnyObject?
        
        request(URLString: URLString, parameters: parameters!, completion: completion)
    }
    
    
    
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - method: <#method description#>
    ///   - URLString: <#URLString description#>
    ///   - parameters: <#parameters description#>
    ///   - completion: <#completion description#>
    func request(method: WBHTTPMethod = .GET, URLString: String, parameters: [String: AnyObject], completion:@escaping (_ json: AnyObject?, _ isSuccess: Bool)->()) {
        
        let success = { (task: URLSessionDataTask, json: Any?)->() in
            completion(json as AnyObject?, true)
        }
        
        let failure = { (task: URLSessionDataTask?, error: Error)->() in
            printLog("\(URLString)  \(parameters)\n\(error)")
            
            if (task?.response as? HTTPURLResponse)?.statusCode == 403 {
                printLog("token outtime")
                
                NotificationCenter.default.post(name: NSNotification.Name(WBUserShouldLoginNotification), object: nil)
            }
            
            completion(nil, false)
        }
        
        
        if method == .GET {
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }else {
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
    }
}



