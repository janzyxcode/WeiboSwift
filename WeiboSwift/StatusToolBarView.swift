//
//  StatusToolBarView.swift
//  WeiboSwift
//
//  Created by  user on 2018/6/21.
//  Copyright © 2018年 nailiao. All rights reserved.
//

import UIKit

class StatusToolBarView: UIView {

    private var lineView: UIView!
    private var retweetedBtn: UIButton!
    private var commentBtn: UIButton!
    private var likeBtn: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)

        lineView = UIView()
        lineView.frame = CGRect(x: statusMargin, y: 0, width: screenWidth - 2*statusMargin, height: 0.5)
        lineView.backgroundColor = rgba(239, 239, 239)
        addSubview(lineView)

        let btnNormalColor = rgba(121, 121, 121)
        let btnDisableColor = UIColor.lightGray
        let btnSelectedColor = rgba(237, 100, 48)
        let btnFontSize: CGFloat = 13

        let btnWidth = width / 3
        let btnHeight: CGFloat = 35
        retweetedBtn = UIButton()
        retweetedBtn.frame = CGRect(x: 0, y: 0.5, width: btnWidth, height: btnHeight)
        retweetedBtn.setTitleColor(btnNormalColor, for: .normal)
        retweetedBtn.setTitleColor(btnDisableColor, for: .disabled)
        retweetedBtn.setImage(#imageLiteral(resourceName: "timeline_icon_retweet"), for: .normal)
        retweetedBtn.setImage(#imageLiteral(resourceName: "timeline_icon_retweet_disable"), for: .disabled)
        retweetedBtn.titleLabel?.font = UIFont.systemFont(ofSize: btnFontSize)
        retweetedBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        addSubview(retweetedBtn)

        commentBtn = UIButton()
        commentBtn.frame = CGRect(x: btnWidth, y: 0.5, width: btnWidth, height: btnHeight)
        commentBtn.setTitleColor(btnNormalColor, for: .normal)
        commentBtn.setTitleColor(btnDisableColor, for: .disabled)
        commentBtn.setImage(#imageLiteral(resourceName: "timeline_icon_comment"), for: .normal)
        commentBtn.setImage(#imageLiteral(resourceName: "timeline_icon_comment_disable"), for: .disabled)
        commentBtn.titleLabel?.font = UIFont.systemFont(ofSize: btnFontSize)
        commentBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        addSubview(commentBtn)

        likeBtn = UIButton()
        likeBtn.frame = CGRect(x: btnWidth*2, y: 0.5, width: btnWidth, height: btnHeight)
        likeBtn.setTitleColor(btnNormalColor, for: .normal)
        likeBtn.setTitleColor(btnDisableColor, for: .disabled)
        likeBtn.setTitleColor(btnSelectedColor, for: .selected)
        likeBtn.setImage(#imageLiteral(resourceName: "timeline_icon_unlike"), for: .normal)
        likeBtn.setImage(#imageLiteral(resourceName: "timeline_icon_like_disable"), for: .disabled)
        likeBtn.setImage(#imageLiteral(resourceName: "timeline_icon_like"), for: .selected)
        likeBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        likeBtn.titleLabel?.font = UIFont.systemFont(ofSize: btnFontSize)
        addSubview(likeBtn)

        let downLineView = UIView()
        downLineView.backgroundColor = rgba(238, 238, 238)
        downLineView.frame = CGRect(x: 0, y: 35.5, width: screenWidth, height: statusMargin)
        addSubview(downLineView)
    }

    func setContent(retweetedStr: String?, commentStr: String?, likeStr: String?) {
        retweetedBtn.setTitle(retweetedStr, for: [])
        commentBtn.setTitle(commentStr, for: [])
        likeBtn.setTitle(likeStr, for: [])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
