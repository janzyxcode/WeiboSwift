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

    private var pullupErrorTimes = 0

    func loadStatus(pullup: Bool, completion: @escaping (_ shouldRefresh: Bool, _ count: Int)->()) {

        if pullup && pullupErrorTimes > maxPullupTryTimes {
            completion(false, 0)
            return
        }

        // 大于0获取最新的
        let since_id = pullup ? 0 : (self.statusList.first?.status.id ?? 0)
        // 大于0获取更早的
        let max_id = !pullup ? 0 : (self.statusList.last?.status.id ?? 0)

        WBStatusListDAL.loadStatus(since_id: since_id, max_id: max_id) { (list) in

            guard let list = list else {
                completion(false, 0)
                return
            }
            printLog("刷新到\(list.count)条")

            var array = [StatusViewModel]()
            for status in list {
                let viewModel = StatusViewModel(status: status)
                array.append(viewModel)
            }

            if pullup && array.count == 0 {
                self.pullupErrorTimes += 1
                completion(false, array.count)
            } else {
                self.cacheSingleImage(list: array, finished: {
                    if pullup {
                        self.statusList += array
                    }else {
                        self.statusList = array + self.statusList
                    }
                    completion(true, array.count)
                })
            }
        }
    }

    private func cacheSingleImage(list: [StatusViewModel], finished: @escaping ()->()) {
        // 优化算法时间
        let group = DispatchGroup()
        for vm in list {
            guard let pictureUrls = vm.picURLs else {
                return
            }

            if pictureUrls.count == 1 {
                let url = pictureUrls[0].isGif ? pictureUrls[0].thumbnail_pic : pictureUrls[0].bmiddle_pic
                if let firstUrl = url {
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
            finished()
        }
    }
}
