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
    private var isPullup = false

    override func loadData() {
        listViewModel.loadStatus(pullup: isPullup) { (shouldRefresh) in

            if self.isPullup {
                printLog("finished11")
                self.tableView?.ngFooterEndRefreshing()
            }else {
                printLog("finished22")
                self.tableView?.ngHeaderEndRefreshing()
            }
            self.isPullup = false

            if shouldRefresh {
                self.tableView?.reloadData()
            }
        }
    }

    @objc func loadMore()  {
        printLog("more")
        isPullup = true
        loadData()
    }

    override func setupContentViews() {
        let table = UITableView(frame: CGRect(x: 0, y: 64, width: view.width, height: view.height - 64 - 49), style: .plain)
        view.addSubview(table)
        tableView = table
        tableView?.delegate = self
        tableView?.dataSource = self

        tableView?.ngHeaderRefreshAddTarget(self, action: #selector(loadData))
        tableView?.ngFooterRefreshAddTarget(self, action: #selector(loadMore))

        tableView?.register(cellType: StatusNormalCell.self)
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 300
        tableView?.separatorStyle = .none

//        HttpsRequest.request(para: RequestParameter(method: .get, url: "https://api.weibo.com/2/emotions.json", parameter: nil), succeed: { (result) in
//            printLog(result)
//        }, failed: nil)
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
        let cell = tableView.dequeueReusableCell(for: indexPath) as StatusNormalCell
        cell.setStatus(model)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

