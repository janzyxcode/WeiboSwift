//
//  LNGSQLiteManger.swift
//  DailySwift
//
//  Created by mac on 17/2/18.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import Foundation
import FMDB

// 最大数据库缓存时间，以 s 为单位
private let maxDBCacheTime: TimeInterval = -5 * 24 * 60 * 60

/// SQLite 管理器
/**
 1、数据库本质上是保存在沙盒中的一个文件，首先需要创建并且打开数据库
    FMDB － 队列
 2、创建数据表
 3、增删改查
 
 
 提示：数据库开发，程序代码几乎一致，区别在 SQL 
 开发数据库功能的时候，首先一定要在 navicat 中测试 SQL 的正确性
 */


/**
 什么数据适合缓存
 - 实时敏感度不高
 - 更新效率低
 - 有查询需求的
 
 例如：菜谱、qq好友、常用的地标
 
 微博不适合
 
 */

class LNGSQLiteManger {

    // 单例，全局数据库工具访问点
    static let shared = LNGSQLiteManger()
    
    // 数据库队列
    let queue: FMDatabaseQueue
    
    // 构造函数 － private： 防止其他地方生存对象
    private init() {
        
        let dbName = "status.db"
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        path = (path as NSString).appendingPathComponent(dbName)
        
        printLog(path)
        
        // 创建数据库队列，同时‘创建或者打开’数据库
        queue = FMDatabaseQueue(path: path)
        
        
        // 打开数据库
        createTable()
        
        // 监听应用程序进入后台
        NotificationCenter.default.addObserver(self, selector: #selector(clearDBCache), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        
        
        /**
         SDImageCache
         // Subscribe to app events
         [[NSNotificationCenter defaultCenter] addObserver:self
         selector:@selector(clearMemory)
         name:UIApplicationDidReceiveMemoryWarningNotification
         object:nil];
         
         [[NSNotificationCenter defaultCenter] addObserver:self
         selector:@selector(cleanDisk)
         name:UIApplicationWillTerminateNotification
         object:nil];
         
         [[NSNotificationCenter defaultCenter] addObserver:self
         selector:@selector(backgroundCleanDisk)
         name:UIApplicationDidEnterBackgroundNotification
         object:nil];

         */
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    /**
     
     清理数据缓存
     注意细节：
     - Sqlite 的数据不断的增加数据，数据库文件的大小，会不断的增加
     - 但是： 如果删除了数据，数据库的带下，不会变小
     - 如果要变小
     - 1：将数据库文件复制一个心的副本，status.db.old
     - 2：新建一个空的数据库文件
     - 3：自己编写 SQL，从 old 中将所有的数据读出，写入新的数据库
     */
    
    
    @objc private func clearDBCache() {
        
        let dateString = Date.ll_dateString(delta: maxDBCacheTime)
        
        printLog("clear \(dateString)")
        
        let sql = "DELETE FROM T_Status WHERE createTime < ?;"
        
        queue.inDatabase { (db) in
        
            if db?.executeUpdate(sql, withArgumentsIn: [dateString]) == true {
                printLog("delete \(db?.changes())")
            }
        }
    }
    
}


extension LNGSQLiteManger {
    
    func updateStatus(userId: String, array: [[String: AnyObject]]) {
        
        /**
         重叠数据，在做数据库操作时，必须处理
         
         OR REPLACE ： 1、如果主键相同，覆盖数据，如果主键不同，新增数据
         */
        let sql = "INSERT OR REPLACE INTO T_Status (statusId, userId, status) VALUES (?, ?, ?);"
        
        queue.inTransaction { (db, rolback) in
            
            for dict in array {
                
                // 从字典获取微博代号／将字典序列化成二进制数据
                guard let statusId = dict["idstr"] as? String,
                      let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: [])
                    else {
                        continue
                }
                
                if db?.executeUpdate(sql, withArgumentsIn: [statusId, userId, jsonData]) == false {
                    printLog("lll")
                    
                    rolback?.pointee = true
                    
                    break
                }
                
                //FIXME:??
                // 模拟回滚
//                rolback?.pointee = true
//                break
            }
            
        }
    }
    
    
    func execRecordSet(sql: String) -> [[String: AnyObject]] {
        
        var result = [[String: AnyObject]]()
        
        // 执行 SQL － 查询数据，不会修改数据，所以不需要开启事务！
        // 事务的目的，是为了保证数据的有效性，一旦失败，回滚到初始状态！
        queue.inDatabase { (db) in
            
            guard let rs = db?.executeQuery(sql, withArgumentsIn: [])
                else {
                    return
            }
            
            while rs.next() {
                
                let colCount = rs.columnCount()
                
                for col in 0..<colCount {
                    
                    guard let name = rs.columnName(for: col),
                        let value = rs.object(forColumnIndex: col)
                        else {
                            continue
                    }
                    
                    result.append([name: value as AnyObject])
                }
            }
            
        }
        
        return result
    }
    
    
    
    /// 从数据库加载微博数据数组
    ///
    ///   - since_id: 返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
    ///   - max_id: 返回ID小于或等于max_id的微博，默认为0
    
    func loadStatus(userId: String, since_id: Int64 = 0, max_id: Int64 = 0) -> [[String: AnyObject]] {
        
        var sql = "SELECT statusId, userId, status FROM T_Status \n"
        sql += "WHERE userId = \(userId) \n"
        
        
        if since_id > 0 {
            sql += "AND statusId > \(since_id) \n"
        }else if max_id > 0 {
            sql += "And statusId < \(max_id) \n"
        }
        
        sql += "ORDER BY statusId DESC LIMIT 20"
        
        printLog(sql)
        
        let array = execRecordSet(sql: sql)
        
        var reslut = [[String: AnyObject]]()
        
        for dict in array {
            
            guard let jsonData = dict["status"] as? Data,
            let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: AnyObject]
             else {
                continue
            }
            
            reslut.append(json ?? [:])
        
        }
        
       return reslut
    }
}


private extension LNGSQLiteManger {
    
    
    func createTable() {
        
        guard let path = Bundle.main.path(forResource: "status.sql", ofType: nil),
            let sql = try? String(contentsOfFile: path)
            else {
            return
        }

        // 执行 SQL － FMDB的内部队列（串行队列，同步执行）
        // _queue = dispatch_queue_create([[NSString stringWithFormat:@"fmdb.%@", self] UTF8String], NULL);
        // 可以保证同一时间，只有一个任务操作数据库，从而保证数据库的读写安全
        queue.inDatabase { (db) in
            
            // 只有在创表的时候，使用执行多条语句，可以一次创建多个数据表
            // 在执行增删改的时候，一定不要使用 statements 方法，否则有可能会被注入
            if db?.executeStatements(sql) == true {
                printLog("success")
            }else {
                printLog("error")
            }
        }
    }
    
}
