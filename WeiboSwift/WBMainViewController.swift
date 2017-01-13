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
        let array = [["className":"WBHomeViewController","title":"首页","imageName":"home",
                      "visitorInfo":["imageName":"", "message": "关注一些人，回这里看看有什么惊喜"]],
                     ["className":"WBMessageViewController","title":"消息","imageName":"message_center","visitorInfo":["imageName":"visitordiscover_image_message", "message": "登录后，别人评论你的微博，发给你的消息，都会在这里收到通知"]],
                     ["className":"UIViewController"],
                     ["className":"WBDiscoverViewController","title":"发现","imageName":"discover",
                      "visitorInfo":["imageName":"visitordiscover_image_message", "message": "登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过"]],
                     ["className":"WBMeViewController","title":"我","imageName":"profile",
                      "visitorInfo":["imageName":"visitordiscover_image_profile", "message": "登录后，你的微博、相册、个人资料会显示在这里，展示给别人"]],
                     ]
        
        (array as NSArray).write(toFile: "/Users/mac/Desktop/demo.plist", atomically: true)
        
        var arrayM = [UIViewController]()
        
        for dict in array {
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
        
        //        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.orange], for: .highlighted)
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
