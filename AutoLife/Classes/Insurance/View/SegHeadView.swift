//
//  SegHeadView.swift
//  AutoLife
//
//  Created by xubupt218 on 16/3/21.
//  Copyright © 2016年 徐成. All rights reserved.
//

import UIKit

class SegHeadView: UIView {
    
    var seg:HMSegmentedControl!
    var indexChangeBlock:((NSInteger) -> Void)?

    init(title:String?,segs:[String]) {
        super.init(frame: CGRectMake(0, 0, XuWidth, title == nil ? 50 : 70))
        var ylos:CGFloat = 29
        if title == nil {
            ylos = 34
            let textField = UITextField(frame: CGRectMake(20,0,XuWidth - 40,30));self.addSubview(textField)
            let bt = UIButton(type: UIButtonType.Custom);bt.setTitle("筛选", forState: UIControlState.Normal)
            bt.frame = CGRectMake(0, 0, 50, 30);textField.rightView = bt
            bt.layer.borderColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1).CGColor
            bt.layer.borderWidth = 0.5
            bt.layer.cornerRadius = XuCornerRadius
            bt.titleLabel?.font = UIFont.systemFontOfSize(XuTextSizeMiddle)
            bt.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            textField.rightViewMode = UITextFieldViewMode.Always
            textField.leftView = UIView(frame: CGRectMake(0,0,10,30))
            textField.leftViewMode = UITextFieldViewMode.Always
            textField.layer.borderColor = XuColorGray.CGColor
            textField.layer.borderWidth = 1
            textField.layer.cornerRadius = 3
            textField.enabled = false
            
            let btn1 = UIButton(type: .Custom)
            btn1.frame = CGRectMake(10, 2, 55, 26)
            btn1.buttonWith(UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1), verticalLine: XuColorWhite, leftTitle: "自驾", rightImage: UIImage(named: "x"))
            btn1.titleLabel?.font = UIFont.systemFontOfSize(XuTextSizeMiddle)
            btn1.layer.cornerRadius = 3
            textField.addSubview(btn1)
            
            let btn2 = UIButton(type: .Custom)
            btn2.frame = CGRectMake(80, 2, 80, 26)
            btn2.buttonWith(UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1), verticalLine: XuColorWhite, leftTitle: "3-15天", rightImage: UIImage(named: "x"))
            btn2.titleLabel?.font = UIFont.systemFontOfSize(XuTextSizeMiddle)
            btn2.layer.cornerRadius = XuCornerRadius
            textField.addSubview(btn2)
        }else {
            let label = UILabel(frame: CGRectMake(12,5,200,20))
            label.text = title;label.font = UIFont.systemFontOfSize(XuTextSizeSmall)
            label.font = UIFont.systemFontOfSize(XuTextSizeMiddle)
            
            self.addSubview(label)
            let btn = UIButton(type: UIButtonType.Custom);btn.frame = CGRectMake(100, 5, 55, 16)
            btn.setTitle("出险处理", forState: UIControlState.Normal)
            btn.backgroundColor = XuColorWhite
            btn.titleLabel?.font = UIFont.systemFontOfSize(XuTextSizeSmall)
            btn.layer.borderColor = XuColorGray.CGColor
            btn.layer.borderWidth = 1
            self.addSubview(btn)
            btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        }
        seg = HMSegmentedControl(frame: CGRectMake(15, ylos, XuWidth - 20, 30))
        seg.titleTextAttributes = [NSFontAttributeName:UIFont.systemFontOfSize(XuTextSizeMiddle),NSForegroundColorAttributeName:XuColorBlue]
        seg.selectedTitleTextAttributes = [NSFontAttributeName:UIFont.systemFontOfSize(XutextSizeBig),NSForegroundColorAttributeName:UIColor.blackColor()]
        seg.backgroundColor = UIColor.clearColor()
        seg.selectionIndicatorColor = UIColor.clearColor()
        seg.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone
        seg.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe
        seg.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic
        seg.selectedSegmentIndex = 0
        seg.selectionIndicatorHeight = 2
        seg.sectionTitles = segs
        seg.isXuStyle = true
        seg.verticalDividerEnabled = true
        seg.verticalDividerColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        self.addSubview(seg)
        seg.indexChangeBlock = { (index) in
            self.indexChangeBlock?(index)
        }
        self.backgroundColor = XuColorBackground
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class FooterView: UIView {
    
    var label:UILabel!
    var btn:UIButton!
    
    init() {
        super.init(frame: CGRectZero)
        label = UILabel(frame: CGRectMake(10,5,100,20))
        self.addSubview(label)
        label.font = UIFont.systemFontOfSize(XuTextSizeMiddle)
        label.text = "旅行随时保"
        btn = UIButton(type: .Custom)
        self.addSubview(btn)
        btn.setImage(UIImage(named: "shopping_cart"), forState: .Normal)
        btn.frame = CGRectMake(80,0,30,30)
        btn.center.x = XuWidth - 40
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
