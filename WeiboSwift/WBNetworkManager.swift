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

/**
 405错误：不支持的网络请求方法
 */

enum WBHTTPMethod {
    case GET
    case POST
}


class WBNetworkManager: AFHTTPSessionManager {
    
    
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
    func tokenRequest(method: WBHTTPMethod = .GET, URLString: String, parameters: [String: AnyObject]?, name: String? = nil, data: Data? = nil, completion: @escaping (_ json: AnyObject?, _ isSuccess: Bool)->()) {
        
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
        
        if let name = name, let data = data {
            upload(URLString: URLString, parameters: parameters, name: name, data: data, completion: completion)
        }
        
        request(method: method, URLString: URLString, parameters: parameters!, completion: completion)
    }
    
    
    //  上传文件必须是 POST 方法， GET 只能获取数据
    func upload(URLString: String, parameters: [String: AnyObject]?, name: String, data: Data, completion: @escaping (_ json: AnyObject?, _ isSuccess: Bool) -> ()) {

        post(URLString, parameters: parameters, constructingBodyWith: { (formDat) in
            
            /**
             data： 要上传的二进制数据
             name： 服务器接收数据的字段名
             fileName： 保存在服务器的文件名，大多数服务器，现在可以乱写
                  很多服务器，上传图片完成后，会生成缩略图，中图，大图
             mimeType: 告诉服务器上传文件的类型，如果不想告诉，可以使用 application/octet-stream image/png image/jpg  image/gif
            */
            formDat.appendPart(withFileData: data, name: name, fileName: "xxx", mimeType: "application/octet-stream")
            
        }, progress: nil, success: { (_, result) in
            
            completion(result as AnyObject, true)
            
        }) { (task, error) in
            if (task?.response as? HTTPURLResponse)?.statusCode == 403 {
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: "bad token")
            }
            
            completion(nil, true)
        }
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



