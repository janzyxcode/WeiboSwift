//
//  Date+Extension.swift
//  WeiboSwift
//
//  Created by liaonaigang on 2017/2/19.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import Foundation

// 日期格式化器 - 不要频繁的释放和创建，会影响性能
private let dateFormatter = DateFormatter()

// 当前日历对象
private let calendar = Calendar.current

extension Date {
    
    // 计算与当前系统时间偏差 delta 秒数的日期字符串
    // 在 swift 中，如果要定义结构体的 ‘类’函数，使用 static 修饰 -> 静态函数
    static func ll_dateString(delta: TimeInterval) -> String {
        
        let date = Date(timeIntervalSinceNow: delta)
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: date)
        
    }
    
    
    static func ll_sinaDate(string: String)->Date? {
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        return dateFormatter.date(from: string)
    }
    
    
    /**
     刚刚（一分钟内）
     X分钟前（一小时内）
     X小时前（当天）
     昨天 HH:mm（昨天）
     MM-dd HH:mm（一年内）
     yyyy-MM-dd HH:mm（更早期)
     
     */
    var ll_dateDescription: String {
        
        if calendar.isDateInToday(self) {
            let delta = -Int(self.timeIntervalSinceNow)
            if delta < 60 {
                return "刚刚"
            }
            
            if delta < 3600 {
                return "\(delta / 60) 分钟前"
            }
            
            return "\(delta / 3600) 小时前"
        }
        
        var fmt = " HH:mm"
        
        if calendar.isDateInYesterday(self) {
            fmt = "昨天" + fmt
        }else {
            fmt = "MM-dd" + fmt
            
            let year = calendar.component(.year, from: self)
            let thiseYear = calendar.component(.year, from: Date())
            
            if year != thiseYear {
                fmt = "yyyy-" + fmt
            }
            
        }
        
        dateFormatter.dateFormat = fmt
        
        return dateFormatter.string(from: self)
    }
}
