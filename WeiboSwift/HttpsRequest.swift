//
//  HttpsRequest.swift
//  ECWallet
//
//  Created by  user on 2018/4/3.
//

import Foundation
import Alamofire

typealias RequestFailedBlock = (_ value: String) -> Void

struct RequestParameter {
    var method: Alamofire.HTTPMethod
    var url: String
    var parameter: [String: Any]?

    init(method: Alamofire.HTTPMethod, url: String, parameter: [String: Any]?) {
        self.method = method
        self.parameter = parameter
        self.url = url
    }
}

struct HttpsRequest {
    // 接口请求并返回模型数据
    static func requestForm<T>(para: RequestParameter,
                               type: T.Type,
                               succeed:@escaping (_ model: T) -> Void,
                               failed: RequestFailedBlock?) where T: Codable {
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        Alamofire.request(para.url,
                          method: para.method,
                          parameters: para.parameter,
                          encoding: URLEncoding.httpBody,
                          headers: headers).responseJSON { (response) in
                            printLog(para.url + "\n" + "\(para.parameter ?? [:])" + "\n" + "\(response)")

                            tokenOutTime(statusCode: response.response?.statusCode)
                            if response.result.isSuccess {  // Success
                                guard let value = response.result.value as? [String: Any] else {
                                    return
                                }

                                if let jsonModel = DecodeJsoner.decodeJsonToModel(dict: value, type) {
                                    succeed(jsonModel)
                                }

                            } else {  // response Failed
                                self.failedResponseHud(message: response.result.error?.localizedDescription, failed: failed)
                            }
        }
    }

    static func request(_ isTakeToken: Bool = true, para: RequestParameter,
                        succeed:@escaping (_ result: [String: Any]) -> Void,
                        failed: RequestFailedBlock?)  {
        var requestPara = para
        if isTakeToken {
            let (status, tokenPara) = appendToken(para: para)
            if status == false {
                return
            }
            requestPara = tokenPara
        }
        Alamofire.request(requestPara.url,
                          method: requestPara.method,
                          parameters: requestPara.parameter).responseJSON { (response) in
                            printLog(requestPara.url + "\n" + "\(requestPara.parameter ?? [:])" + "\n" + "\(response)")

                            tokenOutTime(statusCode: response.response?.statusCode)
                            if response.result.isSuccess {  // Success
                                guard let value = response.result.value as? [String: Any] else {
                                    return
                                }

                                succeed(value)

                            } else {  // response Failed
                                self.failedResponseHud(message: response.result.error?.localizedDescription, failed: failed)
                            }
        }
    }

    static func request<T>(_ isTakeToken: Bool = true, para: RequestParameter,
                           type: T.Type,
                           succeed:@escaping (_ model: T) -> Void,
                           failed: RequestFailedBlock?) where T: Codable {
        var requestPara = para
        if isTakeToken {
            let (status, tokenPara) = appendToken(para: para)
            if status == false {
                return
            }
            requestPara = tokenPara
        }
        Alamofire.request(requestPara.url,
                          method: requestPara.method,
                          parameters: requestPara.parameter).responseJSON { (response) in
                            printLog(requestPara.url + "\n" + "\(requestPara.parameter ?? [:])" + "\n" + "\(response)")

                            tokenOutTime(statusCode: response.response?.statusCode)
                            if response.result.isSuccess {  // Success
                                guard let value = response.result.value as? [String: Any] else {
                                    return
                                }

                                if let jsonModel = DecodeJsoner.decodeJsonToModel(dict: value, type) {
                                    succeed(jsonModel)
                                }

                            } else {  // response Failed
                                self.failedResponseHud(message: response.result.error?.localizedDescription, failed: failed)
                            }
        }
    }

    private static func appendToken(para: RequestParameter) -> (Bool, RequestParameter) {
        guard let token = SingletonData.shared.userAccount?.access_token else {
            NotificationCenter.default.post(name: NSNotification.Name(WBUserShouldLoginNotification), object: nil)
            return (false, para)
        }

        var tokenPara = para
        var dict = para.parameter
        if para.parameter == nil {
            dict = [String: Any]()
        }
        if var dict = dict {
            dict["access_token"] = token
            tokenPara.parameter = dict
        }
        return (true, tokenPara)
    }

    static private func tokenOutTime(statusCode: Int?) {
        if statusCode == 403 {
            printLog("token outtime")
            NotificationCenter.default.post(name: NSNotification.Name(WBUserShouldLoginNotification), object: nil)
        }
    }

    static func failedResponseHud(message: String?, failed: RequestFailedBlock?) {
        if let message = message {
            guard let fail = failed else {
                UIView.windowAdddStatusTextHUD(message)
                return
            }
            fail(message)
        }
    }
}
