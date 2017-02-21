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
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
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
        collectionView.delegate = self
        collectionView.dataSource = self

        
        collectionView.register(LLEmoticonCell.self, forCellWithReuseIdentifier: cellId)
        
        toolbar.delegate = self
        
        
        let bundle = LLEmoticonManager.shared.bundle
        
        guard let normalImage = UIImage(named: "compose_keyboard_dot_normal", in: bundle, compatibleWith: nil),
            let selectedImage = UIImage(named: "compose_keyboard_dot_selected", in: bundle, compatibleWith: nil)
            else {
                return
        }
        
        //        pageControl.pageIndicatorTintColor = UIColor(patternImage: normalImage)
        //        pageControl.currentPageIndicatorTintColor = UIColor(patternImage: selectedImage)
        
        // 使用 看VC 设置私有成员属性
        // 使用运行时查看 类 的私有成员变量
        pageControl.setValue(normalImage, forKey: "_pageImage")
        pageControl.setValue(selectedImage, forKey: "_currentPageImage")
    }
    
  
}

extension LLEmoticonInputView:UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var center = scrollView.center
        center.x += scrollView.contentOffset.x
        
        let paths = collectionView.indexPathsForVisibleItems
        
        var targetIndexPath: IndexPath?
        
        for indexPath in paths {
            
            let cell = collectionView.cellForItem(at: indexPath)
            
            if cell?.frame.contains(center) == true {
                targetIndexPath = indexPath
                break
            }
        }
        
        guard let target = targetIndexPath else {
            return
        }
        
        toolbar.selectIndex = target.section
        
        
        pageControl.numberOfPages = collectionView.numberOfItems(inSection: target.section)
        pageControl.currentPage = target.item
        
    }
    
}

extension LLEmoticonInputView: LLEmoticonToolBarDelegae {
    func emoticonToolBarDidSelectedItemIndex(toolbar: LLEmoticonToolBar, index: Int) {
        let indexpath = IndexPath(item: 0, section: index)
        collectionView.scrollToItem(at: indexpath, at: .left, animated: true)
        
        toolbar.selectIndex = index
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
        
        guard let em = em else {
            return
        }
        
        
        let indexPath = collectionView.indexPathsForVisibleItems[0]
        if indexPath.section == 0 {
            return
        }
        
        
        LLEmoticonManager.shared.recentEmoticon(em: em)
        
        var indexSet = IndexSet()
        indexSet.insert(0)
        collectionView.reloadSections(indexSet)
    }
}
