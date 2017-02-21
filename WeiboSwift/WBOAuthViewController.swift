//
//  WBOAuthViewController.swift
//  WeiboSwift
//
//  Created by mac on 17/1/18.
//  Copyright © 2017年 nailiao. All rights reserved.
//



/*
 URL：
 1、scheme：协议头
 2、host：主机头
 3、pathComponents：路径
 4、query：查询字符串、URL中 ？ 后面所有的内容
 
 */



import UIKit
import SVProgressHUD

class WBOAuthViewController: UIViewController {

    private lazy var webView = UIWebView()
    
    override func loadView() {
        view = webView
        
        view.backgroundColor = UIColor.white
        webView.scrollView.isScrollEnabled = false
        webView.delegate = self
        
        title = "登录"
        
        navigationItem.leftBarButtonItems = UIBarButtonItem.fixtedSpace(title: "返回", target: self, action: #selector(close))
        navigationItem.rightBarButtonItems = UIBarButtonItem.fixtedSpace(title: "自动填充", target: self, action: #selector(autoFill))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(WBAppKey)&redirect_uri=\(WBRedirectURI)"
        guard let url = URL(string: urlString) else {
            return
        }
        
        let request = URLRequest(url: url)
        webView.loadRequest(request)
    }

    
    @objc fileprivate func close() {
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func autoFill() {
       let js = "document.getElementById('userId').value = '18566663496';" + "document.getElementById('passwd').value = '';"
        webView.stringByEvaluatingJavaScript(from: js)
    }
}

extension WBOAuthViewController: UIWebViewDelegate {
    
    // html调用OC的方法
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if request.url?.absoluteString.hasPrefix(WBRedirectURI) == false {
            return true
        }
        
        if request.url?.query?.hasPrefix("code=") == false {
            close()
            return false
        }
        
        let code = request.url?.query?.substring(from: "code=".endIndex) ?? ""
        
        WBNetworkManager.shared.loadAccessToken(code: code) { (isSuccess) in
            
            if !isSuccess {
               SVProgressHUD.showInfo(withStatus: "网络请求失败")
            } else {
                SVProgressHUD.showInfo(withStatus: "登陆成功")
                
                NotificationCenter.default.post(name: NSNotification.Name(WBUserLoginSuccessedNotification), object: nil)
                
                self.close()
            }
        }
        
        return false
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    // 执行 html 页面中的 js 函数（OC中webview和js交互的唯一方法）
    func webViewDidFinishLoad(_ webView: UIWebView) {
       SVProgressHUD.dismiss()
    }
}
