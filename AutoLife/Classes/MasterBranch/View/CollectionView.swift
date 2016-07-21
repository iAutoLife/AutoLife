//
//  CollectionView.swift
//  iAutoLife
//
//  Created by XuBupt on 16/4/25.
//  Copyright © 2016年 xubupt218. All rights reserved.
//

import UIKit

class CollectionView: UIView ,UICollectionViewDelegate,UICollectionViewDataSource{

    private var collection:UICollectionView?
    private var layout = UICollectionViewFlowLayout()
    private var texts = [String]()//:[String] = []
    private var images = [String]()
    
    init(texts:[String],images:[String]) {
       super.init(frame: CGRectZero)
        if texts.count != images.count {
            return
        }
        self.texts = texts
        self.images = images
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        collection = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collection?.delegate = self
        collection?.dataSource = self
        collection?.backgroundColor = UIColor.clearColor()
        self.addSubview(collection!)
        collection?.registerClass(ITCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collection?.scrollEnabled = false
    }
    
    func setLayout(minimumLineSpacing:CGFloat) {
        layout.minimumLineSpacing = minimumLineSpacing
    }
    
    override func layoutSubviews() {
        layout.itemSize = CGSizeMake((frame.width - layout.minimumLineSpacing) / CGFloat(texts.count), frame.height)
        collection?.snp_makeConstraints(closure: { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsetsZero)
        })
        collection?.setNeedsLayout()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ITCollectionViewCell
        cell.setCellWtih(text: texts[indexPath.row], andImage: images[indexPath.row])
        cell.backgroundColor = UIColor.clearColor()
        if layout.minimumLineSpacing == 0 {
            self.layer.cornerRadius = AlStyle.cornerRadius
            self.backgroundColor = AlStyle.color.white
        }else {
            cell.layer.cornerRadius = AlStyle.cornerRadius
            cell.layer.backgroundColor = AlStyle.color.white.CGColor
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.backgroundColor = AlStyle.color.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


class ITCollectionViewCell: UICollectionViewCell {
    
    private var imageView:UIImageView!
    private var label:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView.init()
        self.contentView.addSubview(imageView)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.highlighted = true
        label = UILabel.init()
        label.font = AlStyle.font.normal
        self.contentView.addSubview(label)
    }
    
    override func layoutSubviews() {
        imageView.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.snp_centerY).offset(10).priorityHigh()
            make.centerX.equalTo(self.snp_centerX).priorityHigh()
            make.top.equalTo(frame.height / 6)
        }
        
        label.snp_makeConstraints { (make) in
            make.top.equalTo(imageView.snp_bottom).offset(4).priorityHigh()
            make.centerX.equalTo(self.snp_centerX)
            make.bottom.equalTo(self.snp_bottom).offset(-AlStyle.algebraConvert(10))
        }
    }
    
    func setCellWtih(text text:String, andImage image:String) {
        label.text = text
        imageView.image = UIImage(named: image)
    }
    
    //////?
//    override var selected: Bool {
//        didSet{
//            if selected {
//                self.layer.backgroundColor = AlStyle.color.gray_light.CGColor
//            }else {
//                self.layer.backgroundColor = AlStyle.color.white.CGColor
//            }
//        }
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
