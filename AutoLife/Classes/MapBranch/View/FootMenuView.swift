//
//  FootMenuView.swift
//  AutoLife
//
//  Created by 徐成 on 15/10/27.
//  Copyright © 2015年 徐成. All rights reserved.
//

import UIKit

enum XuFooterViewType:Int {
    case brand = 1,violation,parkTime,revenue
}

typealias FooterViewClickedClosure = ((footerViewType:XuFooterViewType) -> Void)

class FootMenuView: UIView {
    
    let height:CGFloat = 40
    var footerViewClicked:FooterViewClickedClosure?
    
    init(carmaster:CarMaster) {
        let width = UIScreen.mainScreen().bounds.width - 10
        super.init(frame: CGRectMake(0, 0, width, height))
        self.backgroundColor = AlStyle.color.white
        self.layer.cornerRadius = AlStyle.cornerRadius
        self.layer.borderColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1).CGColor
        self.layer.borderWidth = 0.5
        self.layer.shadowColor = UIColor.grayColor().CGColor//UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).CGColor
        self.layer.shadowOffset = CGSizeMake(3, 2)
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 4
        
        self.layer.cornerRadius = AlStyle.cornerRadius
        for i in 1 ..< 4 {
            let line = UIView(frame: CGRectMake(0, 0, 0.5, 20))
            line.backgroundColor = AlStyle.color.gray
            line.center = CGPointMake(CGFloat(i) * width / 4, 20)
            self.addSubview(line)
        }
        
        self.initView(width / 4,carmaster:carmaster)
    }
    
    func clickedAction(sender:UIButton) {
        if self.footerViewClicked != nil {
            self.footerViewClicked!(footerViewType:XuFooterViewType(rawValue: sender.tag)!)
        }
    }
    
    func initView(subWidth:CGFloat,carmaster:CarMaster) {
        //车牌
        let brandView = UIView(frame: CGRectMake(0, 0, subWidth, height))
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(FootMenuView.singleTap(_:)))
        brandView.tag = XuFooterViewType.brand.rawValue
        brandView.addGestureRecognizer(singleTap)
        self.addSubview(brandView)
        
        let imageView = UIImageView(frame: CGRectMake(5, 10, carmaster.logo.size.width, carmaster.logo.size.width))
        imageView.bounds.size = carmaster.logo.size
        imageView.image = carmaster.logo
        imageView.center.y = 20
        brandView.addSubview(imageView)
        
        let brandButton = UIButton(type: UIButtonType.Custom)
        brandButton.frame = CGRectMake(20, 0, subWidth - 20, 40)
        brandButton.titleLabel?.font = AlStyle.font.small
        brandButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        brandButton.addTarget(self, action: #selector(FootMenuView.clickedAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        brandButton.setTitle("\(carmaster.lisencePlate)", forState: UIControlState.Normal)
        brandView.addSubview(brandButton)
        brandButton.tag = XuFooterViewType.brand.rawValue
        
        //违章
        let violationButton = UIButton(type: UIButtonType.Custom)
        violationButton.frame = CGRectMake(subWidth, 0, subWidth, 40)
        violationButton.titleLabel?.font = AlStyle.font.small
        violationButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        violationButton.addTarget(self, action: #selector(FootMenuView.clickedAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        violationButton.setTitle("违章\(carmaster.timesOfViolation) 扣\(carmaster.scoresOfViolation)分", forState: UIControlState.Normal)
        self.addSubview(violationButton)
        violationButton.tag = XuFooterViewType.violation.rawValue
        
        //停车时间
        let parkButton = UIButton(type: UIButtonType.Custom)
        parkButton.frame = CGRectMake(subWidth * 2, 0, subWidth, 40)
        parkButton.titleLabel?.font = AlStyle.font.small
        parkButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        parkButton.addTarget(self, action: #selector(FootMenuView.clickedAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        parkButton.setTitle("停车\(carmaster.timeParking)", forState: UIControlState.Normal)
        self.addSubview(parkButton)
        parkButton.tag = XuFooterViewType.parkTime.rawValue
        
        //分享
        let shareButton = UIButton(type: UIButtonType.Custom)
        shareButton.frame = CGRectMake(subWidth * 3, 0, subWidth, height)
        shareButton.titleLabel?.font = AlStyle.font.small
        shareButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        shareButton.addTarget(self, action: #selector(FootMenuView.clickedAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        shareButton.setTitle("分享 ¥\(carmaster.revenue)", forState: UIControlState.Normal)
        self.addSubview(shareButton)
        shareButton.tag = XuFooterViewType.revenue.rawValue
    }
    
    init() {
        super.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width - 20, 40))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func singleTap(recoginzer:UITapGestureRecognizer) {
        print(recoginzer.view?.tag)
    }
}
