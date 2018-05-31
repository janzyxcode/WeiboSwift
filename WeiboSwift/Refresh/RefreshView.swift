//
//  RefreshView.swift
//  WeiboSwift
//
//  Created by mac on 17/2/9.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

class RefreshView: UIView, NibLoadable {

    var refreshState = NGHeaderRefreshState.normal {
        didSet {
            switch refreshState {
            case .normal:
                tipIcon.isHidden = false
                indicator.stopAnimating()
                tipLabel.text = "下拉刷新"

                UIView.animate(withDuration: 0.3, animations: {
                    self.tipIcon.transform = CGAffineTransform.identity
                })

            case .pulling:
                tipLabel.text = "释放刷新"

                UIView.animate(withDuration: 0.3, animations: {
                    self.tipIcon.transform = CGAffineTransform(rotationAngle: .pi + 0.001)
                })
            case .willRefresh:
                tipLabel.text = "刷新中..."
                tipIcon.isHidden = true
                indicator.startAnimating()
            }
        }
    }

    @IBOutlet weak var tipIcon: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
}
