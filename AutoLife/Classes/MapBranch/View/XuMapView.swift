//
//  XuMapView.swift
//  AutoLife
//
//  Created by 徐成 on 16/1/14.
//  Copyright © 2016年 徐成. All rights reserved.
//

import UIKit

class XuMapView: MAMapView {

    var stepper:XuStepper?
    var trackButton:UIButton?
    
    //MARK: --animationSubview
    func animationSubView(horizontalMove:CGFloat,verticalMove:CGFloat,
        animations:(() -> Void)?,
        completion:(() -> Void)?) {
            UIView.animateWithDuration(0.6,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: [UIViewAnimationOptions.CurveEaseInOut,.AllowUserInteraction],
                animations: { //() -> Void in
                    [weak self] in
                    if let strongSelf = self {
                        strongSelf.stepper?.transform = CGAffineTransformMakeTranslation(horizontalMove, verticalMove)
                        strongSelf.trackButton?.transform = CGAffineTransformMakeTranslation(horizontalMove, verticalMove)
                    }
                    animations?()
                }, completion: { (_) -> Void in completion?() })
    }
    
    func revertSubView(animations:(() -> Void)?,completion:(() -> Void)?) {
        UIView.animateWithDuration(0.6,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: [UIViewAnimationOptions.CurveEaseInOut,.AllowUserInteraction],
            animations: { //() -> Void in
                [weak self] in
                if let strongSelf = self {
                    strongSelf.stepper?.transform = CGAffineTransformIdentity
                    strongSelf.trackButton?.transform = CGAffineTransformIdentity
                }
                animations?()
            }, completion: { (_) -> Void in completion?() })
    }
    
    //MARK: --func
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.compassOrigin = CGPointMake(10, 10)
        self.showsCompass = false
        self.showsScale = false
        self.rotateEnabled = false
        
        let trafficBtn = UIButton(type: UIButtonType.Custom)
        trafficBtn.frame = CGRectMake(AlStyle.size.width - 45, 50, 40, 40)
        trafficBtn.setImage(UIImage(named: "traffic_show"), forState: UIControlState.Normal)
        trafficBtn.setImage(UIImage(named: "traffic_hide"), forState: UIControlState.Normal)
        self.addSubview(trafficBtn)
        
        let feedbackBtn = UIButton(type: UIButtonType.Custom)
        feedbackBtn.frame = CGRectMake(AlStyle.size.width - 45, 95, 40, 40)
        feedbackBtn.setImage(UIImage(named: "feedback"), forState: UIControlState.Normal)
        self.addSubview(feedbackBtn)
        
        
        trackButton = UIButton(type: UIButtonType.Custom);trackButton?.tag = 1
        trackButton?.frame = CGRectMake(5, frame.height - 100, 40, 40)
        trackButton?.setImage(UIImage(named: "track_on"), forState: UIControlState.Normal)
        trackButton?.handleControlEvent(.TouchUpInside) { (_) -> Void in
            if self.userTrackingMode != MAUserTrackingMode.Follow {
                self.userTrackingMode = MAUserTrackingMode.Follow
                self.trackButton?.setImage(UIImage(named: "track_on"), forState: UIControlState.Normal)
            }
            self.setZoomLevel(16 * 3, animated: true)
        }
        self.addSubview(trackButton!)
        
        stepper = XuStepper(style: XuStepperStyle.Vertical, origin: CGPointMake(AlStyle.size.width - 42, AlStyle.size.height - 200), width: 33)
        stepper?.maximumValue = self.maxZoomLevel;stepper?.minimumValue = self.minZoomLevel
        stepper?.value = 7
        self.addSubview(stepper!)
        stepper?.stepperValueChanged = { (sender) in
            self.setZoomLevel(CGFloat(sender.value), animated: true)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
