//
//  UIView+Extensions.swift

//
//  Created by  user on 2017/12/12.
//  Copyright © 2017年 Spring. All rights reserved.
//

import UIKit

extension UIView {

    open var width: CGFloat {
        get {
            return frame.width
        }
        set {
            var fm = self.frame
            fm.size.width = newValue
            self.frame = fm
        }
    }

    open var height: CGFloat {
        get {
            return frame.height
        }
        set {
            var fm = self.frame
            fm.size.height = newValue
            self.frame = fm
        }
    }

    open var top: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            var fm = self.frame
            fm.origin.y = newValue
            self.frame = fm
        }
    }

    open var left: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            var fm = self.frame
            fm.origin.x = newValue
            self.frame = fm
        }
    }

    open var bottom: CGFloat {
        return frame.origin.y + frame.height
    }

    open var right: CGFloat {
        return frame.origin.x + frame.width
    }

    open var centerX: CGFloat {
        get {
            return center.x
        }
        set {
            var cn = self.center
            cn.x = newValue
            self.center = cn
        }
    }

    open var centerY: CGFloat {
        get {
            return center.y
        }
        set {
            var cn = self.center
            cn.y = newValue
            self.center = cn
        }
    }

    //    open var size:CGSize{
    //        get{
    //            return frame.size
    //        }
    //        set{
    //            var fm = self.frame
    //            fm.size = newValue
    //            self.frame = fm
    //        }
    //    }

    open var viewController: UIViewController? {
        var view: UIView?
        var vc: UIViewController?

        view = self
        repeat {
            if let v = view {
                let nextResponder = v.next
                if let responder = nextResponder {
                    if responder.isKind(of: UIViewController.self) {
                        vc = responder as? UIViewController
                        break
                    }
                }
            }
            view = view?.superview
        }while(view != nil)
        return vc
    }

    open func removeAllSubViews() {
        while self.subviews.count > 0 {
            self.subviews.last?.removeFromSuperview()
        }
    }
}

extension UIView {
    func shake() {
        let frame = CAKeyframeAnimation(keyPath: "position.x")
        frame.duration = 0.3
        let x = self.layer.position.x
        frame.values = [(x + 30), (x - 30), (x + 20), (x - 20), (x + 10), (x - 10), (x + 5), (x - 5)]
        layer.add(frame, forKey: "position.x")
    }
}
