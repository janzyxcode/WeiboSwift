//
//  WBStatusListDAL.swift
//  WeiboSwift
//
//  Created by mac on 17/2/18.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import Foundation

/// DAL - Data Access Layer 数据访问层
// 使命：负责处理数据库和网络数据， 给 ListViewModel 返回微博的［字典数组］
// 在调整系统的时候，尽量做最小化的调整
class WBStatusListDAL {
    
    /// 从本地数据库或者网络加载数据
    ///
    /// tips：参数之所以参照网络接口，就是为了保障队原有代码的最小化调整
    ///
    /// - Parameters:
    ///   - since_id: 下拉刷新 id
    ///   - max_id: 上拉刷新 id
    ///   - completion: 完成回调
    class func loadStatus(since_id: Int64 = 0, max_id: Int64 = 0, completion: @escaping (_ list: [[String: AnyObject]]?, _ isSuccess: Bool)->()) {
        
        
        guard let userId = WBNetworkManager.shared.userAccount.uid else {
            return
        }
        
        let array = LNGSQLiteManger.shared.loadStatus(userId: userId, since_id: since_id, max_id: max_id)
        
        // 判断本地返回的数组数量，有数据直接返回，否则请求网络数据
        if array.count > 0 {
            completion(array, true)
            return
        }
        
        WBNetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            
            if !isSuccess {
                completion(nil, false)
                return
            }
            
            guard let list = list else {
                completion(nil, isSuccess)
                return
            }
            
            // 加载完成之后，将网络数据［字典数组］，同步写入数据库
            LNGSQLiteManger.shared.updateStatus(userId: userId, array: list)

            // 返回网络数据
            completion(list,isSuccess)
        }
    }
    
}
