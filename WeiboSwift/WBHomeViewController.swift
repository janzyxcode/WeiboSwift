//
//  WBHomeViewController.swift
//  WeiboSwift
//
//  Created by mac on 17/1/10.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

// 定义全局常量，尽量使用私有属性修饰，否则到处都可以访问
private let cellId = "cellId"


class WBHomeViewController: WBBaseViewController {
    
    //FIXME: 加了private 后 extension不能访问到了
    lazy var statusList = [String]()
    
    
    override func loadData() {
        
        print("start")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            
            for i in 0..<15 {
                if self.isPullup {
                    self.statusList.append("shangla + \(i)")
                }else {
                    self.statusList.insert(i.description, at: 0)
                }
            }
            
            self.refreshControl?.endRefreshing()
            
            self.isPullup = false
            
            print("fresh")
            self.tableView?.reloadData()
        }
        
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
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
        return statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = self.statusList[indexPath.row]
        return cell
    }
}

extension WBHomeViewController {
    override func setUpViews() {
        super.setUpViews()
        
        navItem.leftBarButtonItems = UIBarButtonItem.fixtedSpace(title: "好友", target: self, action: #selector(showFriends))
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
}
