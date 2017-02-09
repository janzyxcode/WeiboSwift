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
    
    
    
}
