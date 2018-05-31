//
//  WBStatusListViewModel.swift
//  WeiboSwift
//
//  Created by mac on 17/1/17.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit
import SDWebImage

// 上拉刷新最大尝试次数
private let maxPullupTryTimes = 3

class WBStatusListViewModel {
    lazy var statusList = [WBStatusViewModel]()
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
            var array = [WBStatusViewModel]()
            
            for status in list {
                let viewModel = WBStatusViewModel(model: status)
                array.append(viewModel)
                
            }
            
           printLog("刷新到\(array.count)条")            
//            printLog("刷新到\(array.count)条  \(array)")
            
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
    
    
    // 缓存本次下载微博数据组中的单张图片
    // 应该缓存玩单张图像，并且修改过配图是的大小之后，再回调，才能够保证表格等比例显示单张图像
    private func cacheSingleImage(list: [WBStatusViewModel], finished: @escaping (_ isSuccess: Bool, _ shouldRefresh: Bool)->()) {
        
        // 调度组
        let group = DispatchGroup()
        
        // 记录数据长度
        var length = 0
        
        for vm in list {
            
            if vm.picURLs?.count != 1 {
                continue
            }
            
            guard let pic = vm.picURLs?[0].thumbnail_pic,
                let url = URL(string: pic) else {
                    continue
            }

            // 下载图片
            // 1、downloadImage 是SDWebImage 的核心方法
            // 2、图像下载完成之后，会自动保存在沙盒中，文件路径是 url 的md5
            // 3、如果沙盒中已经存在缓存的图像，后续使用 SD 通过 URL 加载图像，都会加载本地沙盒图像
            // 4、不会发起网路请求，同事，回调方法，同样会调用
            // 5、方法还是同样额方法，调用还是同样的调用，不过内部不会再次发起网路请求
            // ＊＊＊如果要缓存的图像累计很大，和后台要接口
            
            // 入组
            group.enter()
            
            SDWebImageManager.shared().downloadImage(with: url, options: [], progress: nil, completed: { (image, _, _, _, _) in
                
                if let image = image,
                    let data = UIImagePNGRepresentation(image) {
                    // NSData 是 length 属性
                    length += data.count
                    
                    //  图片缓存成功，更新配图视图的大小
                    vm.updateSingleImageSize(image: image)
                }

                // 出组 － 放在回调的最后一句
                group.leave()
            })
        }
        
        // 监听调度组情况
        group.notify(queue: DispatchQueue.main) { 
            printLog("all cahce  \(length / 1024) k")
            //执行闭包回调
            finished(true, true)
        }
    }
    
}
