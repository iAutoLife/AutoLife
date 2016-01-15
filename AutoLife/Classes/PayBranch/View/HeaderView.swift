//
//  HeaderView.swift
//  ShareAndNav
//
//  Created by xubupt218 on 15/11/13.
//  Copyright © 2015年 徐成. All rights reserved.
//

import UIKit

enum RightButtonStyle {
    case text,textAndImage
}

class HeaderView: UIView {
    
    typealias ButtonAction = (sender:UIButton) -> Void
    var action:ButtonAction?

    init(frame: CGRect,leftText text:String,rightButtonState style:RightButtonStyle,rightButtonText bText:String) {
        super.init(frame: frame)
        let leftLabel = UILabel(frame: CGRectMake(10,frame.height - 20,XuTextSizeMiddle * CGFloat((NSString(string: text)).length),20))
        leftLabel.text = text
        leftLabel.font = UIFont.systemFontOfSize(XuTextSizeMiddle)
        self.addSubview(leftLabel)
        if style == RightButtonStyle.textAndImage {
            HeaderView.AddButtonWith(bText, superView: self)
        }else {
            let button = UIButton(type: UIButtonType.System)
            button.setup(bText, fontsize: XuTextSizeMiddle, fontColor: UIColor.whiteColor(), bkColor: XuColorBlue)
            button.center = CGPointMake(XuWidth - CGRectGetWidth(button.frame) / 2 - 10, frame.height - 10)
            button.handleControlEvent(UIControlEvents.TouchUpInside, withBlock: { (sender) -> Void in
                self.action?(sender: sender)
            })
            self.addSubview(button)
        }
    }
    
    func add(sender:UIButton) {
        self.action?(sender: sender)
    }
    
    class func AddButtonWith(text:String,superView view:UIView) {
        
        let button = UIButton(type: UIButtonType.System)
        let width = XuTextSizeMiddle * CGFloat(NSString(string: text).length) + 10
        button.frame = CGRectMake(XuWidth - width - 10, view.frame.height - 20, width, 20)
        button.setTitle(text, forState: UIControlState.Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(XuTextSizeMiddle)
        button.setTitleColor(XuColorBlueThin, forState: UIControlState.Normal)
        button.addTarget(view, action: "add:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button)
        
        let addBtn = UIButton(type: UIButtonType.System)
        addBtn.frame = CGRectMake(CGRectGetMinX(button.frame) - 30, view.frame.height - 17, 25, 15)
        addBtn.setImage(UIImage(named: "add"), forState: UIControlState.Normal)
        addBtn.addTarget(view, action: "add:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(addBtn)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
