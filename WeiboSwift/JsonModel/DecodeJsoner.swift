//
//  DecodeJsoner.swift
//  ECWallet
//
//  Created by  user on 2018/2/27.
//  Copyright © 2018年 ECW. All rights reserved.
//

import Foundation

struct DecodeJsoner {

    /// 将json数据转换成model对象，该model需要遵守Codale协议
    ///
    /// - Parameters:
    ///   - dict: json数据
    ///   - type: model对象类型
    /// - Returns: 转换成功的对象
    static func decodeJsonToModel<T>(dict: Any, _ type: T.Type) -> T? where T: Codable {
        do {
            let data = try JSONSerialization.data(withJSONObject: dict, options: [])
            let decoder = JSONDecoder()
            let model = try decoder.decode(type, from: data)
            return model
        } catch {
            printLog(type)
            printLog(error)
        }
        return nil
    }

    /// 将Model对象转成json的String值，该对象需要遵守Encodable协议
    ///
    /// - Parameter value: 要转换的对象
    static func encodeModelToString<T>(_ value: T) where T: Encodable {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(value)
            if let dataStr = String(data: jsonData, encoding: .utf8) {
                printLog(dataStr)
            }
        } catch {
            printLog(value)
            printLog(error)
        }
    }

    /// 将json保存到本地
    ///
    /// - Parameter value: model数据
    static func saveModel<T>(toFile: String, value: T) where T: Encodable {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(value)
            FileManager.default.createFile(atPath: toFile, contents: data, attributes: nil)
        } catch {
            printLog(error.localizedDescription)
        }
    }
}
