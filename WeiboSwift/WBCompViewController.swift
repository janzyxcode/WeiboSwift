//
//  WBCompViewController.swift
//  WeiboSwift
//
//  Created by mac on 17/2/13.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

/**
 通过view的背景色和 viewDidLoad里面的一样可以知道，加载视图控制器的时候，如果 XIB 和控制器同名，默认的构造函数，会优先加载 XIB
 */

class WBCompViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    
    @IBOutlet var sendButton: UIButton!
    
    
    // XIB 里 label换行： option ＋ 回车
    // 如果想调整间距，可以增加一个空行，设置空行的字体，lineHeight
    @IBOutlet var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func postStatus(_ sender: UIButton) {
        printLog("post")
    }
    
}


extension WBCompViewController {
    
    func setupUI() {
        
        view.backgroundColor = UIColor.white
        
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
       navigationItem.leftBarButtonItems = UIBarButtonItem.fixtedSpace(title: "关闭", target: self, action: #selector(close))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendButton)
        navigationItem.titleView = titleLabel
        
        
        sendButton.isEnabled = false
    }
}
