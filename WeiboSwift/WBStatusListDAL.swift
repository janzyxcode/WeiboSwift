//
//  WBStatusListDAL.swift
//  WeiboSwift
//
//  Created by mac on 17/2/18.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

/// DAL - Data Access Layer 数据访问层
// 使命：负责处理数据库和网络数据， 给 ListViewModel 返回微博的［字典数组］
// 在调整系统的时候，尽量做最小化的调整
class WBStatusListDAL {
    
    /// 从本地数据库或者网络加载数据
    ///
    /// tips：参数之所以参照网络接口，就是为了保障队原有代码的最小化调整
    ///
    /// - Parameters:
    ///   - since_id: 最新的 id
    ///   - max_id: 最早的 id
    ///   - completion: 完成回调
    class func loadStatus(since_id: Int64 = 0, max_id: Int64 = 0, completion: @escaping (_ list: [StatusModel]?)->()) {

        guard let userId = SingletonData.shared.userAccount?.uid else {
            completion(nil)
            return
        }
        
        let array = LNGSQLiteManger.shared.loadStatus(userId: userId, since_id: since_id, max_id: max_id)
        
        // 判断本地返回的数组数量，有数据直接返回，否则请求网络数据
        if array.count > 0 {
            printLog(array)
            let status = DecodeJsoner.decodeJsonToModel(dict: array, [StatusModel].self)
            completion(status)
            return
        }


        let params = ["since_id": "\(since_id)",
            "max_id": "\(max_id > 0 ? max_id - 1 : 0)"]
        let para = RequestParameter(method: .get, url: "https://api.weibo.com/2/statuses/home_timeline.json", parameter: params)
        HttpsRequest.request(para: para, succeed: { (response) in
            guard let list = response["statuses"] as? [[String: Any]] else {
                completion(nil)
                return
            }

            // 加载完成之后，将网络数据［字典数组］，同步写入数据库
            LNGSQLiteManger.shared.updateStatus(userId: userId, array: list)

            // 返回网络数据
            let status = DecodeJsoner.decodeJsonToModel(dict: list, [StatusModel].self)
            completion(status)

        }, failed: { (message) in
            UIView.windowAdddStatusTextHUD(message)
            completion(nil)
        })
    }
}
