//
//  WBMainViewController.swift
//  WeiboSwift
//
//  Created by mac on 17/1/9.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

class WBMainViewController: UITabBarController {
    
    private lazy var composeButton: UIButton = { ()->UIButton in
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named:"common_button_orange"), for: .normal)
        btn.setBackgroundImage(UIImage(named:"common_button_orange_disable"), for: .highlighted)
        btn.setBackgroundImage(UIImage(named:"common_button_orange_highlighted"), for: .selected)
        btn.setImage(UIImage(named:"tabbar_compose_icon_add"), for: .normal)
        btn.setImage(UIImage(named:"tabbar_compose_icon_add"), for: .highlighted)
        btn.setImage(UIImage(named:"tabbar_compose_icon_add"), for: .selected)
        btn.addTarget(self, action:#selector(composeStatus), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControllers()
        self .setupComposeButton()
    }
    
    
    
    @objc private func composeStatus() {
        print("click")
    }
    
    
    private func setupComposeButton() {
        tabBar.addSubview(composeButton)
        
        let count = CGFloat(childViewControllers.count)
        let width = tabBar.bounds.width / count - 1
        
        composeButton.frame = tabBar.bounds.insetBy(dx: 2 * width, dy: 0)
        
        
    }
    
    private func setupControllers() {
        
        // 沙盒
        let docDict = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let jsonPath = (docDict as NSString).appendingPathComponent("main.json")
        var data = NSData(contentsOfFile: jsonPath)
        
        // 如果沙盒中没有该文件，就从 Bundle 加载 data
        if data == nil {
            let path = Bundle.main.path(forResource: "main.json", ofType: nil)
            data = NSData(contentsOfFile: path!)
            
        }
        

        guard let array = try? JSONSerialization.jsonObject(with: data as! Data, options: []) as? [[String: AnyObject]] else {
                return
        }
        
        
        
        
        var arrayM = [UIViewController]()
        
        for dict in array! {
            arrayM.append(controller(dict: dict as [String : AnyObject]))
        }
        
        viewControllers = arrayM
    }
    
    private func controller(dict: [String: AnyObject]) -> UIViewController {
        
        guard let className = dict["className"] as? String,
            let vcClass = ClassFromString(classString: className as NSString?) as? WBBaseViewController.Type,
            let title = dict["title"] as? String,
            let imageName = dict["imageName"] as? String,
            let visitorDict = dict["visitorInfo"] as? [String: String]
            
            else {
                return UIViewController()
        }
        
        let vc = vcClass.init()
        vc.title = title
        
        vc.visitorInfoDictionary = visitorDict
        
        vc.tabBarItem.image = UIImage(named: "tabbar_" + imageName)
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_" + imageName + "_selected")?.withRenderingMode(.alwaysOriginal)
        
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.orange], for: .selected)
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.darkGray], for: .normal)
//        vc.tabBarItem.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 18)], for: UIControlState(rawValue: 0))
        
        let nav = WBNavigationViewController(rootViewController: vc)
        return nav
    }
    
    
    /*
     portrait   :竖屏，肖像
     landscape     :横屏，风景画
     －代码控制设备的方向，可以再需要横屏的时候单独处理
     －设置支持的方向后，当前的控制器及子控制权都会遵守这个方向
     －视频播放通常是通过 modal 展现的
     */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
