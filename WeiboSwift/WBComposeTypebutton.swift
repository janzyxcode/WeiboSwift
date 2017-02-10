//
//  WBComposeTypebutton.swift
//  WeiboSwift
//
//  Created by mac on 17/2/10.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

class WBComposeTypebutton: UIControl {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    class func composeTypeButton(imageName: String, title: String) -> WBComposeTypebutton {
        
        let nib = UINib(nibName: "WBComposeTypebutton", bundle: nil)
        let btn = nib.instantiate(withOwner: nil, options: nil)[0] as! WBComposeTypebutton
        
        btn.imageView.image = UIImage(named: imageName)
        btn.titleLabel.text = title
        
        return btn
    }
}
