//
//  WBNetworkManager+Extension.swift
//  WeiboSwift
//
//  Created by mac on 17/1/16.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import Foundation

extension WBNetworkManager {
    
    func statusList(completion: @escaping (_ list: [[String: AnyObject]]?, _ isSuccess: Bool)->()) {
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"

        tokenRequest(URLString: urlString, parameters: nil) { (json, isSuccess) in
            print(json as Any)
        }   
    }
    
}
