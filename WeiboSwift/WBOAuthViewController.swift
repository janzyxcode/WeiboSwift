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

    
    @objc private func close() {
        view.hideHUD()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func autoFill() {
       let js = "document.getElementById('userId').value = '18566663496';" + "document.getElementById('passwd').value = 'nailiao04';"
        webView.stringByEvaluatingJavaScript(from: js)
    }
}

extension WBOAuthViewController: UIWebViewDelegate {

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {

        if request.url?.absoluteString.hasPrefix(WBRedirectURI) == false {
            return true
        }
        
        if request.url?.query?.hasPrefix("code=") == false {
            close()
            return false
        }
        
        let code = request.url?.query?.suffix(from: "code=".endIndex) ?? ""

        let urlString = "https://api.weibo.com/oauth2/access_token"
        let params = ["client_id": WBAppKey,
                      "client_secret": WBAppSecret,
                      "grant_type": "authorization_code",
                      "code": String(code),
                      "redirect_uri": WBRedirectURI]
        let para = RequestParameter(method: .post, url: urlString, parameter: params)
        HttpsRequest.requestForm(para: para, type: UserAccount.self, succeed: { (model) in
            SingletonData.shared.userAccount = model
            SingletonData.shared.saveUserAccount()
            self.loadUserInfo()
        }, failed: nil)

        return false
    }

    private func loadUserInfo()  {
        guard let uid = SingletonData.shared.userAccount?.uid else {
            return
        }

        let urlString = "https://api.weibo.com/2/users/show.json"
        let params = ["uid": uid]

        let para = RequestParameter(method: .get, url: urlString, parameter: params)

        HttpsRequest.request(para: para, type: UserAccount.self, succeed: { (model) in
            self.view.addStatusTextHUD("登陆成功")
            SingletonData.shared.userAccount?.screen_name = model.screen_name
            SingletonData.shared.userAccount?.avatar_large = model.avatar_large
            SingletonData.shared.saveUserAccount()
            NotificationCenter.default.post(name: NSNotification.Name(WBUserLoginSuccessedNotification), object: nil)
            self.close()
        }, failed: nil)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        view.addLargeWhiteHUD()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
       view.hideHUD()
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        view.hideHUD()
    }
}
