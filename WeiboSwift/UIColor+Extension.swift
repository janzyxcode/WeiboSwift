 //
 //  UIColor+Extension.swift
 //  DailySwift
 //
 //  Created by mac on 17/1/6.
 //  Copyright © 2017年 nailiao. All rights reserved.
 //
 
 import UIKit
 
 extension UIColor {
    
    class func ColorHex(hex: String) -> UIColor {
        return proceesHex(hex: hex, alpha: 1.0)
    }
    
    class func ColorHexWithAlpha(hex: String, alpha: CGFloat) -> UIColor {
        return proceesHex(hex: hex, alpha: alpha)
    }
    
    class private func proceesHex(hex: String, alpha:CGFloat) -> UIColor {
        
        if hex.isEmpty {
            return UIColor.clear
        }
        
        var hHex = (hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)).uppercased()
        
        if hHex.characters.count < 6 {
            return UIColor.clear
        }
        
        
        if hHex.hasPrefix("0X") {
            hHex = (hHex as NSString).substring(from: 2)
        }
        
        if hHex.hasPrefix("#") {
            hHex = (hHex as NSString).substring(from: 1)
        }
        
        if hHex.hasPrefix("##") {
            hHex = (hHex as NSString).substring(from: 2)
        }
        
        if hHex.characters.count != 6 {
            return UIColor.clear
        }
        
        
        var range = NSMakeRange(0, 2)
        
        let rHex = (hHex as NSString).substring(with: range)
        
        range.location = 2
        let gHex = (hHex as NSString).substring(with: range)
        
        
        range.location = 4
        let bHex = (hHex as NSString).substring(with: range)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
 }
