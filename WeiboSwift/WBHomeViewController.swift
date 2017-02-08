//
//  WBHomeViewController.swift
//  WeiboSwift
//
//  Created by mac on 17/1/10.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit
import AFNetworking

// 定义全局常量，尽量使用私有属性修饰，否则到处都可以访问
private let originalCellId  = "originalCellId"
private let retweetedCellId = "retweetedCellId"

class WBHomeViewController: WBBaseViewController {
    
    //FIXME: 加了private 后 extension不能访问到了
    lazy var listViewModel = WBStatusListViewModel()
    
    
    override func loadData() {
        
        
        listViewModel.loadStatus(pullup: self.isPullup) { (isSuccess) in
            
            self.refreshControl?.endRefreshing()
            self.isPullup = false
            self.tableView?.reloadData()
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
        let request = WBNetworkManager()
        request.statusList { (_, _) in
            
        }
        
    }
    
    //FIXME:为什么不能加 private
    @objc func showFriends() {
        print(#function)
        let vc = WBDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
}


extension WBHomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
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
        
        return cell
    }
}

extension WBHomeViewController {
    override func setUpViews() {
        super.setUpViews()
        
        navItem.leftBarButtonItems = UIBarButtonItem.fixtedSpace(title: "好友", target: self, action: #selector(showFriends))
        
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
