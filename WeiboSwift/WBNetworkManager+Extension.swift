//
//  WBNetworkManager+Extension.swift
//  WeiboSwift
//
//  Created by mac on 17/1/16.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import Foundation

extension WBNetworkManager {
    
    
    /// 加载微博数据字典数字
    ///
    /// - Parameters:
    ///   - since_id: 返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
    ///   - max_id: 返回ID小于或等于max_id的微博，默认为0
    ///   - completion: 完成回调
    func statusList(since_id: Int64 = 0, max_id: Int64 = 0, completion: @escaping (_ list: [[String: AnyObject]]?, _ isSuccess: Bool)->()) {
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"

        let params = ["since_id": "\(since_id)",
            "max_id": "\(max_id > 0 ? max_id - 1 : 0)"]
        
        tokenRequest(URLString: urlString, parameters: params as [String : AnyObject]?) { (json, isSuccess) in
            let result = json?["statuses"] as? [[String: AnyObject]]
            completion(result, isSuccess)
        }   
    }
    
}
