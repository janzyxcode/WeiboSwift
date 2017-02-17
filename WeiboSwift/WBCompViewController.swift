//
//  WBCompViewController.swift
//  WeiboSwift
//
//  Created by mac on 17/2/13.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit
import SVProgressHUD

/**
 通过view的背景色和 viewDidLoad里面的一样可以知道，加载视图控制器的时候，如果 XIB 和控制器同名，默认的构造函数，会优先加载 XIB
 */

class WBCompViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet var sendButton: UIButton!
    
    @IBOutlet weak var toolbarBottomCons: NSLayoutConstraint!
    
    // XIB 里 label换行： option ＋ 回车
    // 如果想调整间距，可以增加一个空行，设置空行的字体，lineHeight
    @IBOutlet var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChanged), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        textView.resignFirstResponder()
    }
    
    @objc private func keyboardChanged(n: Notification) {
        
        guard let rect = (n.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = (n.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
            
        else {
            return
        }
        
        let offset = view.bounds.height - rect.origin.y
        toolbarBottomCons.constant = offset
        
        UIView.animate(withDuration: duration) { 
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func postStatus(_ sender: UIButton) {
        
        guard let text = textView.text else {
            return
        }
        
        
//        let image = UIImage(named: "icon_courier")
        

        WBNetworkManager.shared.postStatus(text: text, image: nil) { (result, isSuccess) in
            
            SVProgressHUD.setDefaultMaskType(.gradient)
            
            let message = isSuccess ? "发布成功" : "网络不给力"
            
            SVProgressHUD.showInfo(withStatus: message)
            
            if isSuccess {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    SVProgressHUD.setDefaultMaskType(.clear)
                    self.close()
                })
            }
        }
    }
    
    
    @objc private func emoticonKeyboard() {
    
        // textView.inputView 就是文本框的输入视图
        // 如果使用系统默认的键盘，输入视图为 nil
        
        let keyboardView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 253))
        keyboardView.backgroundColor = UIColor.blue
        
        // 设置键盘视图
        textView.inputView = keyboardView
        
        // 刷新键盘视图
        textView.reloadInputViews()
    }
    
}

extension WBCompViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        sendButton.isEnabled = textView.hasText
    }
}


extension WBCompViewController {
    
    func setupUI() {
        
        view.backgroundColor = UIColor.white
        textView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        
        setupNavigationBar()
        setupToolbar()
    }
    
    func setupNavigationBar() {
        
       navigationItem.leftBarButtonItems = UIBarButtonItem.fixtedSpace(title: "关闭", target: self, action: #selector(close))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendButton)
        navigationItem.titleView = titleLabel
        
        
        sendButton.isEnabled = false
    }
    
    
    func setupToolbar() {
        
        let itemSettings = [["imageName": "compose_toolbar_picture"],
                            ["imageName": "compose_mentionbutton_background"],
                            ["imageName": "compose_trendbutton_background"],
                            ["imageName": "compose_emoticonbutton_background", "actionName": "emoticonKeyboard"],
                            ["imageName": "compose_toolbar_more"]]
        
        var items = [UIBarButtonItem]()
        
        for s in itemSettings {
            
            guard let imageName = s["imageName"] else {
                continue
            }
            
            let image = UIImage(named: imageName)
            let imageHL = UIImage(named: imageName + "_highlighted")
            
            let btn = UIButton()
            btn.setImage(image, for: [])
            btn.setImage(imageHL, for: .highlighted)
            btn.sizeToFit()
            items.append(UIBarButtonItem(customView: btn))
            
            if let actionName = s["actionName"] {
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            }
            
            // 追加弹簧
            items.append((UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)))
        }
        
        items.removeLast()
        
        toolbar.items = items
    }
}
