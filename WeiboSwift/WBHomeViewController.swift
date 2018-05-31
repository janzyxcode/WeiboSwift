//
//  WBHomeViewController.swift
//  WeiboSwift
//
//  Created by mac on 17/1/10.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit


// 定义全局常量，尽量使用私有属性修饰，否则到处都可以访问
private let originalCellId  = "originalCellId"
private let retweetedCellId = "retweetedCellId"

class WBHomeViewController: WBBaseViewController {

    var tableView: UITableView?
    lazy private var listViewModel = WBStatusListViewModel()
    private var isUpload = true

    override func loadData() {
        listViewModel.loadStatus(pullup: isUpload) { (isSuccess, shouldRefresh) in
            printLog("ennloadata")
            if self.isUpload == false {
                self.tableView?.ngFooterEndRefreshing()
            }else {
               self.tableView?.ngHeaderEndRefreshing()
            }
            self.isUpload = true

            if shouldRefresh {
                self.tableView?.reloadData()
            }
        }
    }

    @objc func loadMore()  {
        printLog("more")
        loadData()
        isUpload = false
    }
    

    override func setupContentViews() {
        let table = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(table)
        tableView = table
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.contentInset = UIEdgeInsetsMake(64, 0, tabBarController?.tabBar.bounds.height ?? 49, 0)
        // 修改指示器的缩进
        tableView?.scrollIndicatorInsets = tableView!.contentInset

        tableView?.ngHeaderRefreshAddTarget(self, action: #selector(loadData))
        tableView?.ngFooterRefreshAddTarget(self, action: #selector(loadMore))

        tableView?.register(UINib(nibName: "WBStatusNormalCell", bundle: nil), forCellReuseIdentifier: originalCellId)
        tableView?.register(UINib(nibName: "WBStatusReweetedCell", bundle: nil), forCellReuseIdentifier: retweetedCellId)
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 300
        tableView?.separatorStyle = .none
    }

}


extension WBHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let vm = listViewModel.statusList[indexPath.row]
        return vm.rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let vm = listViewModel.statusList[indexPath.row]
        let cellId = (vm.status.retweeted_status != nil) ? retweetedCellId : originalCellId
        
        // 取 cell － 本身会调用代理方法（如果有）
        // 如果没有，找到 cell， 按照自动布局的规则，从上向下计算，找到向下的约束，从而计算动态行高
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WBStatusCell
        cell.viewModel = vm
        
        
        // 如果用block 需要在数据源方法中，给每一个 cell 设置 block
        // cell.completionBlock = { // ... }
        // 设置代理只是传递一个指针地址
        cell.delegate = self
        
        return cell
    }
}

extension WBHomeViewController: WBstatusCellDelegate {
    
    func statusCellDidSelectedURLString(cell: WBStatusCell, urlString: String) {
        
        let vc = WBWebViewController()
        vc.urlString = urlString
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}


