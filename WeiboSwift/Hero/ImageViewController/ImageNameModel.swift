//
//  ImageNameModel.swift
//  ECWallet
//
//  Created by  user on 2018/3/1.
//

import UIKit

enum ImageViewerNameType {
    case name
    case url
    case image
}

struct ImageNameModel {
    var name: String
    var type: ImageViewerNameType
    var heroID: String            // hero转场标识，如果为空，无效果
    var haveLoaded = false
    var image: UIImage?
    var placeholder: UIImage?
    
    init(name: String, type: ImageViewerNameType = .name, heroID: String, _ image: UIImage? = nil, _ placeholder: UIImage? = nil) {
        self.name = name
        self.type = type
        self.heroID = heroID
        self.image = image
        self.placeholder = placeholder
    }

    mutating func setLoad(_ loaded: Bool) {
        haveLoaded = loaded
    }
}
