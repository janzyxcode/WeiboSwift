//
//  WBHomeViewController.swift
//  WeiboSwift
//
//  Created by mac on 17/1/10.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

class WBHomeViewController: WBBaseViewController {

    var tableView: UITableView?
    lazy private var listViewModel = WBStatusListViewModel()
    private var isUpload = true

    override func loadData() {
        listViewModel.loadStatus(pullup: isUpload) { (isSuccess, shouldRefresh) in
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

        tableView?.register(cellType: StatusNormalCell.self)
//        tableView?.register(UINib(nibName: "WBStatusNormalCell", bundle: nil), forCellReuseIdentifier: originalCellId)
//        tableView?.register(UINib(nibName: "WBStatusReweetedCell", bundle: nil), forCellReuseIdentifier: retweetedCellId)
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
        let model = listViewModel.statusList[indexPath.row]
        return model.layout.rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = listViewModel.statusList[indexPath.row]
//        let cellId = (vm.status.retweeted_status != nil) ? retweetedCellId : originalCellId
        let cell = tableView.dequeueReusableCell(for: indexPath) as StatusNormalCell
        cell.setStatus(model)
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


