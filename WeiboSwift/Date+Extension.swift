//
//  Date+Extension.swift
//  WeiboSwift
//
//  Created by liaonaigang on 2017/2/19.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import Foundation

extension Date {
    
    // 计算与当前系统时间偏差 delta 秒数的日期字符串
    // 在 swift 中，如果要定义结构体的 ‘类’函数，使用 static 修饰 -> 静态函数
    static func ll_dateString(delta: TimeInterval) -> String {
        let formatter = SingletonData.shared.formatter
        let date = Date(timeIntervalSinceNow: delta)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }

    //FIXME:是否影响加载速度3
    static func createdAtDeal(_ dateStr: String?) -> String? {
        guard let dateStr = dateStr else {
            return nil
        }

        let formatter = SingletonData.shared.formatter
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"


        guard let createdAtDate = formatter.date(from: dateStr) else {
            return nil
        }


        let calender = SingletonData.shared.calendar
        if calender.isDateInToday(createdAtDate) {
            let seconds = -Int(createdAtDate.timeIntervalSinceNow)
            if seconds < 60 {
                return "刚刚"
            } else if seconds < 3600 {
                return "\(seconds/60)分钟前"
            } else {
                return "\(seconds/3600)小时前"
            }
        } else if calender.isDateInYesterday(createdAtDate) {
            formatter.dateFormat = "昨天 HH:mm"
            return formatter.string(from: createdAtDate)
        } else {
            let thisYear = calender.component(.year, from: Date())
            let dateYear = calender.component(.year, from: createdAtDate)
            if thisYear == dateYear {
                formatter.dateFormat = "MM-dd HH:mm"
                return formatter.string(from: createdAtDate)
            } else {
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                return formatter.string(from: createdAtDate)
            }
        }
    }
}
