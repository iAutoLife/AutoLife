//
//  NumberView.swift
//  AutoLife
//
//  Created by xubupt218 on 16/1/26.
//  Copyright © 2016年 徐成. All rights reserved.
//

import UIKit

class NumberView: UIView ,UICollectionViewDataSource,UICollectionViewDelegate{
    
    private var collectionView:UICollectionView!
    private let provinces = ["1","2","3","4","5","6","7","8","9","0"]
    var selectItem:((String)->Void)?

    init() {
        super.init(frame: CGRectMake(0, 0, XuWidth, 45))
        let layout = UICollectionViewFlowLayout()
        let width:CGFloat = (XuWidth == 375 ? 30 : 24)
        layout.itemSize = CGSizeMake(width, 36)
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        layout.minimumInteritemSpacing = 5
        collectionView = UICollectionView(frame: CGRectMake(0, 0, frame.width, frame.height), collectionViewLayout: layout)
        self.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = XuColorGrayThin
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "ccell")

    }
    //MARK:--UICollectionViewDelegate
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return provinces.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ccell", forIndexPath: indexPath)
        let label = UILabel(frame: cell.contentView.frame)
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(20, weight: 1)
        label.frame = cell.contentView.frame
        label.text = provinces[indexPath.row]
        cell.contentView.addSubview(label)
        cell.backgroundColor = UIColor.whiteColor()
        cell.layer.cornerRadius = XuCornerRadius
        cell.layer.shadowColor = UIColor.grayColor().CGColor
        cell.layer.shadowOffset = CGSizeMake(0, 2)
        cell.layer.shadowOpacity = 1
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.cellForItemAtIndexPath(indexPath)?.backgroundColor = XuColorGrayThin
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.cellForItemAtIndexPath(indexPath)?.backgroundColor = UIColor.whiteColor()
        selectItem?(provinces[indexPath.row])
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
