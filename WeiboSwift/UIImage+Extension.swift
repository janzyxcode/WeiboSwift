//
//  UIImage+Extension.swift
//  WeiboSwift
//
//  Created by mac on 17/1/9.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

extension UIImage {
    
    func selectedImage(imageName: String) -> UIImage? {
        let image = UIImage(named: imageName + "_selected")
        return image
    }
    
    func highlightedImage(imageName: String) -> UIImage? {
        let image = UIImage(named: imageName + "_highlighted")
        return image
    }
    
    
    // 将给定的图像进行拉伸，并且返回 ‘新’的图像
    func avatarImage(size: CGSize?, backColor: UIColor = UIColor.white, lineColor: UIColor = UIColor.lightGray, lineWidth: CGFloat = 0) -> UIImage? {
        
        var size = size
        if size == nil {
            size = self.size
        }

        let rect = CGRect(origin: CGPoint(), size: size!)
        
        // 1、图像上下文－内存中开辟一个地址，跟屏幕无关
        /**
         参数：
         1> size：绘图的尺寸
         2> 不透明：false／true
         3> scale：屏幕分辨率，默认生成的图像默认使用 1.0 的分辨率，图像质量不好，可以知道 0，会选择当前设备的屏幕分辨率
         */
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)

        backColor.setFill()
        UIRectFill(rect)

        let path = UIBezierPath(ovalIn: rect)
        path.addClip()

        self.draw(in: rect)

        if lineWidth > 0 {
            let ovalPath = UIBezierPath(ovalIn: rect)
            ovalPath.lineWidth = lineWidth
            lineColor.setStroke()
            ovalPath.stroke()
        }

        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    
    func ll_normalDraw(size: CGSize?) -> UIImage? {
        
        var size = size
        if size == nil {
            size = self.size
        }
        
        let rect = CGRect(origin: CGPoint(), size: size!)
        
        // 1、图像上下文－内存中开辟一个地址，跟屏幕无关
        /**
         参数：
         1> size：绘图的尺寸
         2> 不透明：false／true
         3> scale：屏幕分辨率，默认生成的图像默认使用 1.0 的分辨率，图像质量不好，可以知道 0，会选择当前设备的屏幕分辨率
         */
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)

        //  绘图
        self.draw(in: rect)
                
        //  取得结果
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        // 关闭上下文
        UIGraphicsEndImageContext()
        
        return result
    }

}
