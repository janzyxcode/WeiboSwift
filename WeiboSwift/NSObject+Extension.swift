//
//  NSObject+Extension.swift
//  DailySwift
//
//  Created by mac on 16/12/30.
//  Copyright © 2016年 nailiao. All rights reserved.
//

import Foundation

extension NSObject {
    
    /**
     Throung string get class (may be nil).
     */
   open func ClassFromString(classString:NSString?) -> AnyClass? {
        
        var getClass:AnyClass?
    
        if let classString = classString {
            getClass = NSClassFromString(Bundle.main.namespace + "." + (classString as String))
        }
        
        return getClass
    }
    
    
    
    /// 返回档期累的属性数组
    ///
    /// - Returns: 属性数组
    class func ll_propertyList() -> [String] {
        var count:UInt32 = 0
        
        var array:[String] = []
        
        //  获取‘类’的属性列表，返回属性列表的数组，可选项
        let list = class_copyPropertyList(self, &count)
        
//        print(count)
//        
//        for i in 0..<Int(count) {
//            
//            // 根据下标获取属性
//            // 使用 guard 语法，依次判断每一项是否有值，只要有一项为nil，就不再执行后续的代码
//            guard let pty = list?[i],
//                let cName = property_getName(pty),
//                let name = String(utf8String: cName)
//                
//                else {
//                    // 继续遍历下一个
//                    continue
//            }
//            array.append(name)
//        }
        
        free(list)
        
        return array
    }
    
    
    //FIXME:看 ivar 和 property 的区别
    
    /// 返回当前累的成员变量数组
    ///
    /// - Returns: 成员变量数组
    class func ll_ivarList() -> [String] {
        
        var array:[String] = []
        
        var count:UInt32 = 0
        let ivars = class_copyIvarList(self, &count)
        
        for i in 0..<Int(count) {
            
            guard let ivar = ivars?[i],
                let cName = ivar_getName(ivar),
                let name = String(utf8String: cName)
                
                else {
                    continue
            }
            array.append(name)
        }
        
        return array
    }
}
