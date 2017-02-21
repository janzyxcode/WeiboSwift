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
    
    lazy fileprivate var listViewModel = WBStatusListViewModel()
    
    override func loadData() {
        printLog("laodata")
        listViewModel.loadStatus(pullup: self.isPullup) { (isSuccess, shouldRefresh) in
            printLog("ennloadata")
            if self.isPullup == true {
                self.addPageControl?.endRefreshing()
            }else {
               self.refreshControl?.endRefreshing()
            }
            
            
            self.isPullup = false
            
            if shouldRefresh {
                self.tableView?.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
    }
    

    @objc fileprivate func showFriends() {
        let vc = WBDemoViewController()
        navigationController?.pushViewController(vc, animated: true)   
    }
}


extension WBHomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let vm = listViewModel.statusList[indexPath.row]
        return vm.rowHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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

extension WBHomeViewController {
    override func setUpViews() {
        super.setUpViews()
        
//        navItem.leftBarButtonItems = UIBarButtonItem.fixtedSpace(title: "好友", target: self, action: #selector(showFriends))
        
        tableView?.register(UINib(nibName: "WBStatusNormalCell", bundle: nil), forCellReuseIdentifier: originalCellId)
        tableView?.register(UINib(nibName: "WBStatusReweetedCell", bundle: nil), forCellReuseIdentifier: retweetedCellId)
        //        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 300
        tableView?.separatorStyle = .none
        
        setupNavTitle()
    }
    
    private func setupNavTitle() {
        
        let title = WBNetworkManager.shared.userAccount.screen_name
        
        let button = WBTitleButton(title: title)
        button.addTarget(self, action: #selector(clickTitleButton(btn:)), for: .touchUpInside)
        navItem.titleView = button
    }
    
    @objc func clickTitleButton(btn: UIButton){
        btn.isSelected = !btn.isSelected
    }
}
