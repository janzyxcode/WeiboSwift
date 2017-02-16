//
//  WBMainViewController.swift
//  WeiboSwift
//
//  Created by mac on 17/1/9.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBMainViewController: UITabBarController,UITabBarControllerDelegate {
    
    //FIXME:private
    lazy var composeButton: UIButton = { ()->UIButton in
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
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControllers()
        self .setupComposeButton()
        self.setupTimer()
        
        setupNewFeatureViews()
        
        delegate = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(userLogin), name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
    }
    
    func userLogin(n: Notification) {
        
        var when = DispatchTime.now()
        
        
        if n.object != nil {
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.showInfo(withStatus: "用户登陆已经超时，需要重新登陆")
            
            when = DispatchTime.now() + 2
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: when) {
            printLog("test")
            SVProgressHUD.setDefaultMaskType(.clear)
            
            let nav = UINavigationController(rootViewController: WBOAuthViewController())
            self.present(nav, animated: true, completion: nil)
        }
        
        
    }
    
    deinit {
        timer?.invalidate()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc private func composeStatus() {
        
        let v = WBComposeTypeView.composeTypeView()
        v.show { [weak v] (clsName) in
            guard let clsName = clsName, let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? UIViewController.Type
                else {
                    return
            }
            
            let nibvc = cls.init(nibName: clsName, bundle: nil)
//            let vc = cls.init()
            let nav = UINavigationController(rootViewController: nibvc)
            
            self.present(nav, animated: true, completion: {
                v?.removeFromSuperview()
            })
        }
        
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let idx = (childViewControllers as NSArray).index(of: viewController)
        if selectedIndex == 0 && idx == selectedIndex {
            let nav = childViewControllers[0] as! UINavigationController
            let vc = nav.childViewControllers[0] as! WBHomeViewController
            
            vc.tableView?.scrollToTop()
            
            // 刷新数据 － 增加延迟，保证表格先滚动到顶部再刷新
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                vc.loadData()
            })
            
            vc.tabBarItem.badgeValue = nil
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
        return !viewController.isMember(of: UIViewController.self)
        
        /*
         isKindOfClass和isMemberOfClass之间的区别是：
         我们可以使用isKindOfClass来确定一个对象是否是一个类的实例，或者是该类祖先类的实例。
         isMemberOfClass只能用来判断前者，不能用来判断后者。
         
         可以说：isMemberOfClass不能检测任何的类都是基于NSObject类这一事实，而isKindOfClass可以
         */
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


private extension WBMainViewController {
    
    func setupNewFeatureViews() {
        
        if !WBNetworkManager.shared.userLogon {
            return
        }
        
        let v = isNewVersion ? WBNewFeatureView.newFeatureView() : WBWelcomeView.welcomeView()
        v.frame = view.bounds
        view.addSubview(v)
    }
    
    // extension 中可以有计算机型属性，不会占用存储空间
    /*
     版本号
     － 在 App Store 每次升级应用程序，只能增加
     － 组成 主版本号、次版本号、修订版本号
     － 主版本号：意味大的修改
     － 次版本号：意味小的版本号
     － 修订版本号：框架／ 程序内部 bug 的修订，不会对使用者造成任何的影响
 */
    var isNewVersion: Bool {
        
        let currentVerison = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
        
        let libarayPaths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        
        guard let libarayPath = libarayPaths.first else {
            return true
        }
        
        let versionPath = libarayPath + "/version"
        
        let cacheVersion = try? String(contentsOfFile: versionPath, encoding: .utf8)
        
        _ = try? currentVerison.write(toFile: versionPath, atomically: true, encoding: .utf8)
        
        return currentVerison != cacheVersion
    }
}

extension WBMainViewController {
    
    func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        
        if !WBNetworkManager.shared.userLogon {
            return
        }
        
        WBNetworkManager.shared.unreadCount { (count) in
            
            self.tabBar.items?[0].badgeValue = count > 0 ? "\(count)" : nil
            
            // 授权才能显示
            UIApplication.shared.applicationIconBadgeNumber = count
        }
    }
}


// extension 类似于 OC 中的分类，在Swift中还可以用来切分代码块
//可以把相近似功能的函数，放在一个 extension中，便于代码维护
//  和 OC 的分类一样，extension中不能定义属性
extension WBMainViewController {
    
    func setupComposeButton() {
        tabBar.addSubview(composeButton)
        
        let count = CGFloat(childViewControllers.count)
        let width = tabBar.bounds.width / count
        
        composeButton.frame = tabBar.bounds.insetBy(dx: 2 * width, dy: 0)
        
    }
    
    func setupControllers() {
        
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
}

