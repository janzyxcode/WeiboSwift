//
//  StatusPictureImageView.swift
//  WeiboSwift
//
//  Created by  user on 2018/6/26.
//  Copyright © 2018年 nailiao. All rights reserved.
//

import UIKit

class StatusPictureImageView: UIImageView {

    let typeImgv = UIImageView()
    var isGif: Bool = false {
        didSet {
            typeImgv.isHidden = !isGif
            typeImgv.image = UIImage(named: "timeline_image_gif")
        }
    }

    var isLongPicture: Bool = false {
        didSet {
            typeImgv.isHidden = !isLongPicture
            typeImgv.image = UIImage(named: "compose_image_longimage")
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentMode = .scaleAspectFill
        clipsToBounds = true
        isUserInteractionEnabled = true

        typeImgv.isHidden = true
        typeImgv.contentMode = .scaleAspectFill
        addSubview(typeImgv)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        typeImgv.frame = CGRect(x: width - 30, y: height - 15, width: 30, height: 15)
    }


}
