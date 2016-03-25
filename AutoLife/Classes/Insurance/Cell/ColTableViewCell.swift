//
//  ColTableViewCell.swift
//  AutoLife
//
//  Created by xubupt218 on 16/3/21.
//  Copyright © 2016年 徐成. All rights reserved.
//

import UIKit

@objc protocol ColTableViewCellDelegate {
    optional func colItemDidChanged(index:Int)
    optional func colItemCellDidSelected(row:Int)
}

class ColTableViewCell: UITableViewCell ,UICollectionViewDataSource,UICollectionViewDelegate{

    private var datas:NSArray = []
    private var num = 6
    var delegate:ColTableViewCellDelegate?
    var colView:UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    init(datas:NSArray) {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: "ccell")
        self.selectionStyle = UITableViewCellSelectionStyle.None
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.itemSize = CGSizeMake(XuWidth - 20, CGFloat(datas[0].count) * 60)
        layout.minimumLineSpacing = 0
        colView = UICollectionView(frame: CGRectMake(0, 0, XuWidth - 20, CGFloat(datas[0].count) * 60), collectionViewLayout: layout)
        colView.registerClass(TbCollectionViewCell.self, forCellWithReuseIdentifier: "col")
        self.contentView.addSubview(colView)
        colView.delegate = self
        colView.dataSource = self
        colView.pagingEnabled = true
        colView.backgroundColor = UIColor.clearColor()
        colView.showsHorizontalScrollIndicator = false
        self.datas = datas
        colView.clipsToBounds = false
    }
    
    func colScrollToItem(index:Int) {
        self.colView.setContentOffset(CGPointMake((XuWidth - 20) * CGFloat(index),0), animated: true)
    }
    
    //MARK:--UICollectionViewDelegate
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return num
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("col", forIndexPath: indexPath) as! TbCollectionViewCell
        cell.set(self.datas, frame: collectionView.frame)
        cell.clipsToBounds = false
        cell.cellDidSelectedIn = { (row) in
            self.delegate?.colItemCellDidSelected?(row)
        }
        return cell
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.delegate?.colItemDidChanged?(Int(ceil(scrollView.contentOffset.x / (XuWidth - 20))))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class TbCollectionViewCell: UICollectionViewCell ,UITableViewDataSource,UITableViewDelegate{
    private var tableView:UITableView!
    private var texts = [String]()
    private var deTexts = [String]()
    
    var cellDidSelectedIn : ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: CGRectMake(0, 0, XuWidth, frame.height))
        self.backgroundColor = UIColor.clearColor()
        self.clipsToBounds = true
        tableView = UITableView(frame: CGRectMake(0, 0, XuWidth, frame.height))
        tableView.backgroundColor = UIColor.clearColor()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.scrollEnabled = false
        tableView.rowHeight = 60
        tableView.registerClass(WidthSubTitleTableViewCell.self, forCellReuseIdentifier: "wCell")
        tableView.registerNib(UINib(nibName: "WidthSubTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "wCell")
        self.contentView.addSubview(tableView)
        self.backgroundColor = UIColor.clearColor()
    }
    
    func set(datas:NSArray,frame:CGRect) {
        texts = datas[0] as! [String]
        deTexts = datas[1] as! [String]
    }
    
    //MARK:--UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.texts.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return texts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("wCell") as! WidthSubTitleTableViewCell
        cell.backgroundColor = UIColor.clearColor()
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.setTitle(texts[indexPath.row], detailTitle: deTexts[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        self.cellDidSelectedIn?(Int(indexPath.row))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
