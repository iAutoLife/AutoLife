//
//  ProvincesView.swift
//  AutoLife
//
//  Created by xubupt218 on 16/1/26.
//  Copyright © 2016年 徐成. All rights reserved.
//

import UIKit

class ProvincesView: UIView ,UICollectionViewDataSource,UICollectionViewDelegate{

    private var collectionView:UICollectionView!
    private let provinces = ["京","津","冀","晋","蒙","辽","吉","黑","沪","苏","浙","皖","闽","赣","鲁","豫","鄂","湘","粤","桂","琼","渝",
        "川","贵","云","藏","陕","甘","青","宁","新"]
    var selectItem:((String?)->Void)?
    private var hintView:UIView!
    
    init(oy:CGFloat) {
        super.init(frame: CGRectMake(0, oy, AlStyle.size.width, 216))
        let layout = UICollectionViewFlowLayout()
        let width:CGFloat = (AlStyle.size.width == 375 ? 30 : 24)
        layout.itemSize = CGSizeMake(width, 36)
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        collectionView = UICollectionView(frame: CGRectMake(0, 0, frame.width, frame.height), collectionViewLayout: layout)
        self.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = AlStyle.color.gray_light
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "ccell")
        
        let button = UIButton(type: UIButtonType.Custom)
        button.backgroundColor = AlStyle.color.blue
        let oXW:(CGFloat,CGFloat) = (AlStyle.size.width == 375 ? 294.5 : 251.5,AlStyle.size.width == 375 ? 70 : 58)
        button.frame = CGRectMake(oXW.0, 148, oXW.1, 36)
        button.titleLabel?.font = AlStyle.font.normal
        button.addTarget(self, action: #selector(ProvincesView.finished(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        button.setTitle("完 成", forState: UIControlState.Normal)
        button.layer.cornerRadius = AlStyle.cornerRadius
        self.addSubview(button)
    }
    
    func finished(sender:UIButton) {
        self.selectItem?(nil)
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
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
        label.font = AlStyle.font.normal
        label.frame = cell.contentView.frame
        label.text = provinces[indexPath.row]
        cell.contentView.addSubview(label)
        cell.backgroundColor = UIColor.whiteColor()
        cell.layer.cornerRadius = AlStyle.cornerRadius
        cell.layer.shadowColor = UIColor.grayColor().CGColor
        cell.layer.shadowOffset = CGSizeMake(0, 2)
        cell.layer.shadowOpacity = 1
//        cell.layer.shadowRadius = 4
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectItem?(provinces[indexPath.row])
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        print(collectionView.cellForItemAtIndexPath(indexPath)?.frame)
        print("didHighlightItemAtIndexPath")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


