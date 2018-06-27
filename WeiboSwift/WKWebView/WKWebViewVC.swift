//
//  WKWebViewVC.swift

//
//  Created by liaonaigang on 2017/12/30.
//  Copyright © 2017年 Spring. All rights reserved.
//

import UIKit
import WebKit

class WKWebViewVC: UIViewController {

    let webView = WKWebView()
    private lazy var progressView = UIProgressView()
    var urlStr: String?
    private var haveBeRequest = false
    lazy private var progressObervations = [NSKeyValueObservation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }


    func setupViews() {
        webView.frame = view.bounds
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.contentInset = UIEdgeInsets(top: statusNaviBarHeight, left: 0, bottom: 0, right: 0)
        webView.scrollView.neverAdjustsScrollViewInsets()
        view.addSubview(webView)

        addProgressView()
    }

    func startLoading() {
        guard let urlString = urlStr ,
            let url = URL(string: urlString)
            else {
                return
        }
        let request = URLRequest(url: url)
        webView.load(request)

        view.addLargeWhiteHUD()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if haveBeRequest == false {
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    self.startLoading()
                }
            }
        }
    }

    deinit {
        for item in progressObervations {
            item.invalidate()
        }
        progressObervations.removeAll()
    }
}

extension WKWebViewVC {
    private func addProgressView() {
        progressView.frame = CGRect(x: 0, y: statusNaviBarHeight, width: view.width, height: 100)
        progressView.progressTintColor = rgba(79, 195, 38, 1)
        progressView.progress = 0
        progressView.trackTintColor = UIColor.clear
        view.addSubview(progressView)

        let options = NSKeyValueObservingOptions.new.union(NSKeyValueObservingOptions.old)
        let observer = webView.observe(\.estimatedProgress,
                                       options: options) { [weak self] (_, _) in
            self?.observeEstimatedProgress()
        }
        progressObervations.append(observer)
    }

    private func observeEstimatedProgress() {
        progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        if webView.estimatedProgress == 1 {
            UIView.animate(withDuration: 0.5, animations: {
                self.progressView.alpha = 0
            })
        }
    }
}

extension WKWebViewVC: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {

    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        haveBeRequest = true
        view.hideHUD()
printLog(webView.url)
        webView.evaluateJavaScript("document.getElementsByClassName('video-player')[0].getElementsByClassName('video')[0].src") { (result, _) in
            printLog(result)
        }
        webView.insertImagesJS()
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        progressFinished()
        view.hideHUD()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        progressFinished()
        if haveBeRequest == false {
            view.addStatusTextHUD("接超时！")
        }
        haveBeRequest = true
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        printLog(navigationAction.request.url)
        // 图片浏览器
        webView.showImageViewer(navigationAction.request)

        // 跳转下一界面
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        decisionHandler(.allow)
    }
}

extension WKWebViewVC {
    private func progressFinished() {
        progressView.alpha = 0
    }
}
