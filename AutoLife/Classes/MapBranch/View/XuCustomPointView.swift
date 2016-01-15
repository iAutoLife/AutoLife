//
//  XuCustomPointView.swift
//  AutoLife
//
//  Created by 徐成 on 16/1/15.
//  Copyright © 2016年 徐成. All rights reserved.
//

import UIKit

class XuCustomPointView: UIView {
    
    var titleLabel:UILabel!
    var detailLabel:UILabel!
    var usableLabel:UILabel?
    var moreButton:UIButton!
    
    //MARK: --init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(poi:AMapPOI,index:Int) {
        super.init(frame: CGRectMake(0, 0, XuWidth - 60, 100))
        self.initSubView(poi)
    }
    
    func initSubView(poi:AMapPOI) {
        titleLabel = UILabel(frame: CGRectMake(10,5,self.frame.width - 20, XuTextSizeMiddle))
        titleLabel.font = UIFont.systemFontOfSize(XuTextSizeMiddle)
        self.addSubview(titleLabel)
        
        detailLabel = UILabel(frame: CGRectMake(30,5,self.frame.width - 20, XuTextSizeMiddle))
        detailLabel.font = UIFont.systemFontOfSize(XuTextSizeSmall)
        detailLabel.textColor = XuColorGray
        self.addSubview(detailLabel)
        
        moreButton = UIButton(type: UIButtonType.Custom)
        moreButton.frame = CGRectMake(self.frame.width - 60, 30, 50, 20)
        moreButton.titleLabel?.font = UIFont.systemFontOfSize(XuTextSizeMiddle)
        moreButton.setImage(UIImage(named: ""), forState: UIControlState.Normal)
        moreButton.setTitle("详情", forState: UIControlState.Normal)
        self.addSubview(moreButton)
        
        
        titleLabel.text = poi.name
        detailLabel.text = poi.address
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
