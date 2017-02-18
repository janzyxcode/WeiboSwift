//
//  LLEmoticonInputView.swift
//  KeyboardInput
//
//  Created by mac on 17/2/17.
//  Copyright © 2017年 nailiao. All rights reserved.
//

import UIKit

private let cellId = "cellId"

class LLEmoticonInputView: UIView {

    @IBOutlet weak var toolbar: LLEmoticonToolBar!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // 选中表情回调包属性
    var selectedEmoticonCallBack: ((_ emoticon: LLEmoticon?)->())?
    
    
    class func inputView(selectedEmoticon: @escaping (_ emoticon: LLEmoticon?)->()) -> LLEmoticonInputView {
        
        let nib = UINib(nibName: "LLEmoticonInputView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! LLEmoticonInputView
        
        v.selectedEmoticonCallBack = selectedEmoticon
        
        return v
    }

    override func awakeFromNib() {
        
        collectionView.backgroundColor = UIColor.white
//        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(LLEmoticonCell.self, forCellWithReuseIdentifier: cellId)
    }
    
}

extension LLEmoticonInputView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return LLEmoticonManager.shared.packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return LLEmoticonManager.shared.packages[section].numberOfPages
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! LLEmoticonCell

        cell.emoticons = LLEmoticonManager.shared.packages[indexPath.section].emoticon(page: indexPath.item)
        cell.delegate = self
        return cell
    }
}


extension LLEmoticonInputView: LLEmoticonCellDelegate {
    func emoticonCellDidSelectedEmoticon(cell: LLEmoticonCell, em: LLEmoticon?) {
        selectedEmoticonCallBack?(em)
    }
}
