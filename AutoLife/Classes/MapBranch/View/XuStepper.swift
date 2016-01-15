//
//  XuStepper.swift
//  AutoLife
//
//  Created by 徐成 on 15/12/14.
//  Copyright © 2015年 徐成. All rights reserved.
//

import UIKit

enum XuStepperStyle {
    case Horizontal,Vertical        //横向排布、纵向排布
}

class XuStepper: UIControl {
    
    var value:CGFloat = 0{
        didSet{
            if maximumValue - value < 1 {
                self.incrementButton.enabled = false
            }else if value - minimumValue < 1 {
                self.decrementButton.enabled = false
            }else {
                self.incrementButton.enabled = true
                self.incrementButton.enabled = true
            }
        }
    }
    var minimumValue:CGFloat = 0
    var maximumValue:CGFloat = 100
    var stepValue:CGFloat = 2
    var incrementImage = UIImage(named: "increment")
    var unIncrementImage = UIImage(named: "unincrement")
    var decrementImage = UIImage(named: "decrement")
    var unDecrementImage = UIImage(named: "undecrement")
    var wraps = false
    var autoRepeat = false
    var autoRepeatInterval:NSTimeInterval = 0.5
    private var incrementButton:UIButton!
    private var decrementButton:UIButton!
    
    var stepperValueChanged:((XuStepper) -> Void)?
    
    //MARK: --init
    init(style:XuStepperStyle,origin:CGPoint,width:CGFloat) {
        if style == XuStepperStyle.Horizontal {
            super.init(frame: CGRectMake(origin.x, origin.y, width * 2, width))
        }else {
            super.init(frame: CGRectMake(origin.x, origin.y, width, width * 2))
        }
        self.setupStepperButton(style, width: width)
        self.backgroundColor = UIColor.redColor()
        print(width)
    }
    
    func setupStepperButton(style:XuStepperStyle,width:CGFloat) {
        incrementButton = UIButton(type: UIButtonType.Custom)
        incrementButton.frame = CGRectMake(0, 0, width, width)
        //incrementButton.setImage(incrementImage, forState: UIControlState.Normal)
        incrementButton.setBackgroundImage(incrementImage, forState: UIControlState.Normal)
        incrementButton.setBackgroundImage(unIncrementImage, forState: UIControlState.Disabled)
        incrementButton.autoresizingMask = UIViewAutoresizing.None
        incrementButton.addTarget(self, action: "touchDownIncrement:", forControlEvents: UIControlEvents.TouchDown)
        incrementButton.addTarget(self, action: "touchUpIncrement:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(incrementButton)
        
        var lineRect = CGRectMake(width - 0.25,5,0.51,width)
        decrementButton = UIButton(type: UIButtonType.Custom)
        if style == XuStepperStyle.Horizontal {
            decrementButton.frame = CGRectMake(width, 0, width, width)
        }else {
            decrementButton.frame = CGRectMake(0, width, width, width)
            lineRect = CGRectMake(5, width - 0.25, width - 10, 0.51)
        }
        decrementButton.setBackgroundImage(decrementImage, forState: UIControlState.Normal)
        decrementButton.setBackgroundImage(unDecrementImage, forState: UIControlState.Disabled)
        decrementButton.addTarget(self, action: "touchDownDecrement:", forControlEvents: UIControlEvents.TouchDown)
        decrementButton.addTarget(self, action: "touchUpDecrement:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(decrementButton)
        let view = UIView(frame: lineRect)
        view.backgroundColor  = UIColor(red: 0.852, green: 0.8521, blue: 0.852, alpha: 1)
        self.addSubview(view)
    }
    
    //MARK: --control event
    func touchDownIncrement(sender:UIControl) {
        guard self.stepperValueChanged != nil else {return}
        value += stepValue
        if value > maximumValue {
            if wraps {value = minimumValue}
            else{
                value = maximumValue
                sender.enabled = false
                NSObject.cancelPreviousPerformRequestsWithTarget(self)
            }
        }
        stepperValueChanged?(self)
        if autoRepeat {
            self.performSelector("touchDownIncrement:", withObject: nil, afterDelay: autoRepeatInterval)
        }
    }
    
    func touchDownDecrement(sender:UIControl) {
        guard stepperValueChanged != nil else {return}
        value -= stepValue
        if value < minimumValue {
            if wraps {value = maximumValue}
            else{
                NSObject.cancelPreviousPerformRequestsWithTarget(self)
                value = minimumValue
                sender.enabled = false
            }
        }
        stepperValueChanged?(self)
        if autoRepeat {
            self.performSelector("touchDownDecrement:", withObject: nil, afterDelay: autoRepeatInterval)
        }
    }
    
    func touchUpIncrement(sender:UIControl) {
        NSObject.cancelPreviousPerformRequestsWithTarget(self)
    }
    
    func touchUpDecrement(sender:UIControl) {
        NSObject.cancelPreviousPerformRequestsWithTarget(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
