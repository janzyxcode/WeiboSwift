//
//  WBStatusListViewModel.swift
//  WeiboSwift
//
//  Created by mac on 17/1/17.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

// 上拉刷新最大尝试次数
private let maxPullupTryTimes = 3

class WBStatusListViewModel {
    lazy var statusList = [StatusViewModel]()

    // 上次刷新错误次数
    private var pullupErrorTimes = 0

    func loadStatus(pullup: Bool, completion: @escaping (_ isSuccess: Bool, _ shouldRefresh: Bool)->()) {
        if pullup && pullupErrorTimes > maxPullupTryTimes {
            completion(false, false)
            return
        }
        
        // 取出数组中第一条微博的 ID
        let since_id = pullup ? 0 : (self.statusList.first?.status.id ?? 0)
        // 上拉刷新，取出数组的最后一条微博 ID
        let max_id = !pullup ? 0 : (self.statusList.last?.status.id ?? 0)

        WBStatusListDAL.loadStatus(since_id: since_id, max_id: max_id) { (list, isSuccess) in

            if !isSuccess {
                completion(false, false)
                return
            }

            guard let list = list else {
                return
            }
            var array = [StatusViewModel]()
            
            for status in list {
                let viewModel = StatusViewModel(status: status)
                array.append(viewModel)
            }
            
            printLog("刷新到\(array.count)条")

            if pullup {
                self.statusList += array
            }else {
                self.statusList = array + self.statusList
            }
            
            if pullup && array.count == 0 {
                self.pullupErrorTimes += 1
                completion(isSuccess, false)
            } else {
                self.cacheSingleImage(list: array, finished: completion)
            }
        }
    }

    private func cacheSingleImage(list: [StatusViewModel], finished: @escaping (_ isSuccess: Bool, _ shouldRefresh: Bool)->()) {

        let group = DispatchGroup()
        for vm in list {
            guard let pictureUrls = vm.picURLs else {
                return
            }

            if pictureUrls.count == 1 {
                if let firstUrl = pictureUrls[0].thumbnail_pic {
                    group.enter()
                    vm.pictureViews[0].waitAndGetImageSize(firstUrl) { (singleSize) in
                        if singleSize.equalTo(CGSize.zero) == false {
                            vm.updateSingleImageSize(singleSize, vm.pictureViews[0])
                        }
                        group.leave()
                    }
                }
            }
        }

        group.notify(queue: DispatchQueue.main) {
            finished(true, true)
        }
    }
}
