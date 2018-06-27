//
//  WKWebView+Extensions.swift
//  ECWallet
//
//  Created by  user on 2018/3/9.
//

import WebKit

private var imageUrls = [String]()
private var clickFuncName = "ngweb:imageclick"

extension WKWebView {
    func insertImagesJS() {

        // 1.初始化图片容器
        imageUrls = [String]()

        // 2.获取网页中全部图片的url，并拼接起来
        let insertGetImageJs = """
        function getImages(){\
        var objs = document.getElementsByTagName(\"img\");\
        var imgUrlStr='';\
        for(var i=0;i<objs.length;i++){\
        imgUrlStr+=objs[i].src+'<->';\
        \
        objs[i].onclick=function imageClick(){\
        document.location=\"\(clickFuncName):\"+this.src;\
        client.open(1);\
        }\
        };\
        return imgUrlStr;\
        };
        """

        evaluateJavaScript(insertGetImageJs) { (result, erro) in
            printLog(result)
            printLog(erro?.localizedDescription)
        }

        // 3.获取拼接字符串
        let getImageJs = "getImages()"
        evaluateJavaScript(getImageJs) { (result, erro) in
            //            printLog(result)
            printLog(erro?.localizedDescription)

            guard let resultString = result as? String else {
                return
            }
            // 4.截取字符串
            self.getSubArray(resultString)
            // 5.去重
            if imageUrls.count > 0 {
                self.removeRepeateUrl(0)
            }

        }
    }

    private func getSubArray(_ string: String) {
        let array = string.components(separatedBy: "<->")
        for item in array {
            if item.contains("http://") {
                imageUrls.append(item)
            }
        }
    }

    private func removeRepeateUrl(_ index: Int) {
        if index >= imageUrls.count - 1 {
            return
        }

        var i = index + 1
        while imageUrls.count > i {
            if imageUrls[index] == imageUrls[i] {
                imageUrls.remove(at: i)
            }
            i += 1
        }
        removeRepeateUrl(index + 1)
    }

    func showImageViewer(_ request: URLRequest) {
        if imageUrls.count < 1 {
            return
        }
        guard let urlString = request.url?.absoluteString else {
            return
        }

        if urlString.contains(clickFuncName) {
            var index = 0
            var heroArray = [ImageNameModel]()
            for item in imageUrls.enumerated() {
                if item.element == urlString.substring(from: clickFuncName.count + 1) {
                    index = item.offset
                }
                heroArray.append(ImageNameModel(name: item.element, type: .url, heroID: ""))
            }

            synchronized(lock: self, closure: {
                let vc = ImageViewController.instantiate()
                vc.selectedIndex = IndexPath(row: index, section: 0)
                vc.imageLibrary = heroArray
                self.viewController?.present(vc, animated: true, completion: nil)
            })
        }
    }
}

extension WKWebView {
    func clearAllCache() {
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }

    }
}
