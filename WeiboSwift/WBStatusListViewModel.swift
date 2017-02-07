//
//  WBStatusListViewModel.swift
//  WeiboSwift
//
//  Created by mac on 17/1/17.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit


// 微博数据列表视图模型

/*
 父类的选择
 － 如果类需要使用 ‘KVC‘ 或者字典转模型框架设置对象值，类就需要继承自 NSObject
 － 如果类只是包装一些代码逻辑（写了一些函数），可以不用任何父类，好处：更加轻量级
 － 提示：如果用 OC 写，一律都继承自 NSObject 即可
 
 */


// 上拉刷新最大尝试次数
private let maxPullupTryTimes = 3

class WBStatusListViewModel {
    
    lazy var statusList = [WBStatusViewModel]()
    
    // 上次刷新错误次数
    private var pullupErrorTimes = 0
    
    
    func loadStatus(pullup: Bool, completion: @escaping (_ isSuccess: Bool, _ shouldRefresh: Bool)->()) {
        
        if pullup && pullupErrorTimes > maxPullupTryTimes {
            completion(true, false)
            return
        }
        
        // 取出数组中第一条微博的 ID
        let since_id = pullup ? 0 : (self.statusList.first?.status.id ?? 0)
        // 上拉刷新，取出数组的最后一条微博 ID
        let max_id = !pullup ? 0 : (self.statusList.last?.status.id ?? 0)
        
        
        
        WBNetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
          
            if !isSuccess {
                completion(false, false)
                return
            }
            
            var array = [WBStatusViewModel]()
            
            for dict in list ?? [] {
                let status = WBStatus()
                status.yy_modelSet(with: dict)
                let viewModel = WBStatusViewModel(model: status)
                array.append(viewModel)
            }
            
            
            print("刷新到\(array.count)条  \(array)")
            
            if pullup {
                self.statusList += array
            }else {
               self.statusList = array + self.statusList
            }
            
            if pullup && array.count == 0 {
                self.pullupErrorTimes += 1
                completion(isSuccess, false)
            } else {
                completion(isSuccess, true)
            }
            
        }
    }
    
}
