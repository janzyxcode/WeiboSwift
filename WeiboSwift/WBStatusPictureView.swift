//
//  WBStatusPictureView.swift
//  WeiboSwift
//
//  Created by mac on 17/2/7.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

class WBStatusPictureView: UIView {
    
    var viewModel: WBStatusViewModel? {
        didSet {
            //FIXME
            calcVIewSize()
            urls = viewModel?.picURLs
        }
    }
    
    // 根据视图模型的配图视图大小，调整显示内容
    private func calcVIewSize() {
        
        // 处理宽度
        // 单图。更加视图的大小，修改 subviews[0] 的宽高
        if viewModel?.picURLs?.count == 1 {
            let viewSize = viewModel?.pictureViewSize ?? CGSize()
            
            let v = subviews[0]
            v.frame = CGRect(x: 0,
                             y: WBStatusPictureViewOutterMargin,
                             width: viewSize.width,
                             height: viewSize.height - WBStatusPictureViewOutterMargin)
            
        }else {
            
            // 多图，恢复subview[0]的宽高，保证九宫格布局的完整
            let v = subviews[0]
            v.frame = CGRect(x: 0,
                             y: WBStatusPictureViewOutterMargin,
                             width: WBStatusPictureItemWidth,
                             height: WBStatusPictureItemWidth)
            
        }
        
        heightCons.constant = viewModel?.pictureViewSize.height ?? 0
    }
    
    
    var urls: [StatusPictureModel]? {
        didSet {
            for v in subviews {
                v.isHidden = true
            }
            
            var index = 0
            for url in urls ?? [] {
                
                let iv = subviews[index] as! UIImageView
                
                if index == 1 && urls?.count == 4 {
                    index += 1
                }
                iv.ll_setImage(urlString: url.thumbnail_pic, placeholderImage: nil)
                
               iv.subviews[0].isHidden = (((url.thumbnail_pic ?? "") as NSString).pathExtension.lowercased() != "gif")
                
                iv.isHidden = false
                index += 1
            }
            
        }
    }
    
    
    @objc fileprivate func tapImageview(tap: UITapGestureRecognizer) {
        
        
        guard let iv = tap.view,
        let picURLs = viewModel?.picURLs
            else {
            return
        }
        
        var selectedIndex = iv.tag
        
        if picURLs.count == 4 && selectedIndex > 1 {
            selectedIndex -= 1
        }
        
        let urls = (picURLs as NSArray).value(forKey: "thumbnail_pic") as! [String]
        
        var imageViewList = [UIImageView]()
        
        for iv in subviews as! [UIImageView] {
            if !iv.isHidden {
                imageViewList.append(iv)
            }
        }
        
        printLog(selectedIndex)
        printLog(urls)
        
        
        let photoBrowser = SDPhotoBrowser()
        photoBrowser.delegate = self
        photoBrowser.currentImageIndex = selectedIndex
        photoBrowser.imageCount = picURLs.count
        photoBrowser.sourceImagesContainerView = self
        photoBrowser.show()
    }
    
    @IBOutlet weak var heightCons: NSLayoutConstraint!
    
    override func awakeFromNib() {
        setupUI()
    }
    
}


extension WBStatusPictureView: SDPhotoBrowserDelegate {
    
    func photoBrowser(_ browser: SDPhotoBrowser!, placeholderImageFor index: Int) -> UIImage! {
        
        let imgv = subviews[index] as! UIImageView
        return imgv.image
    }
    
    func photoBrowser(_ browser: SDPhotoBrowser!, highQualityImageURLFor index: Int) -> URL! {
       let urlStr = viewModel?.picURLs?[index].thumbnail_pic!.replacingOccurrences(of: "thumbnail", with: "bmiddle")
        return URL(string: urlStr!)!
    }    
}



extension WBStatusPictureView {
    
    func setupUI() {
        
        backgroundColor = superview?.backgroundColor
        clipsToBounds = true
        
        let count = 3
        let rect = CGRect(x: 0, y: WBStatusPictureViewOutterMargin, width: WBStatusPictureItemWidth, height: WBStatusPictureItemWidth)
        
        for i in 0..<count * count {
            
            let row = CGFloat(i / count)
            let col = CGFloat(i % count)
            let xOffset = col * (WBStatusPictureItemWidth + WBStatusPictureViewInnerMargin)
            let yOffset = row * (WBStatusPictureItemWidth + WBStatusPictureViewInnerMargin)
            
            let iv = UIImageView()
            iv.isUserInteractionEnabled = true
            iv.frame = rect.offsetBy(dx: xOffset, dy: yOffset)
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            iv.tag = i
            addSubview(iv)
            
            addGifView(iv: iv)
            
            let tapG = UITapGestureRecognizer(target: self, action: #selector(tapImageview(tap:)))
            iv.addGestureRecognizer(tapG)
            
        }
        
    }
    
    private func addGifView(iv: UIImageView){
        
        let gifImgv = UIImageView(image: UIImage(named: "timeline_image_gif"))
        
        iv.addSubview(gifImgv)
        
        // 自动布局
         gifImgv.translatesAutoresizingMaskIntoConstraints = false
        
        iv.addConstraint(NSLayoutConstraint(item: gifImgv, attribute: .right, relatedBy: .equal, toItem: iv, attribute: .right, multiplier: 1.0, constant: 0))
        iv.addConstraint(NSLayoutConstraint(item: gifImgv, attribute: .bottom, relatedBy: .equal, toItem: iv, attribute: .bottom, multiplier: 1.0, constant: 0))
    }
    
}
