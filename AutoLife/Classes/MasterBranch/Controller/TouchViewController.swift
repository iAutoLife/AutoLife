//
//  TouchViewController.swift
//  iAutoLife
//
//  Created by XuBupt on 16/4/28.
//  Copyright © 2016年 xubupt218. All rights reserved.
//

import UIKit
import LocalAuthentication

class TouchViewController: UIViewController {
    
    private var headView = UIImageView()
    private var touchButton = AlButton(type: UIButtonType.Custom)
    private var changeUserBtn = UIButton(type: UIButtonType.Custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AlStyle.color.white
        self.layoutSubviews()
        self.touchIdentfy(touchButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return UIStatusBarStyle.LightContent
//    }
    
    func layoutSubviews() {
        headView.image = UIImage(named: "autolife")
        view.addSubview(headView)
        
        touchButton.setTitle("点击进行已有指纹验证", forState: UIControlState.Normal)
        touchButton.setTitleColor(AlStyle.color.blue, forState: UIControlState.Normal)
        touchButton.setImage(UIImage(named: "logo"), forState: UIControlState.Normal)
        touchButton.gapForIT = 15
        touchButton.titleLabel?.font = AlStyle.font.normal
        touchButton.style = AlButtonStyleVertical.imageAboveTitle
        touchButton.addTarget(self, action: #selector(touchIdentfy(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(touchButton)
        
        changeUserBtn.setTitle("登录其他账户", forState: UIControlState.Normal)
        changeUserBtn.setTitleColor(AlStyle.color.blue, forState: UIControlState.Normal)
        changeUserBtn.titleLabel?.font = AlStyle.font.normal
        changeUserBtn.addTarget(self, action: #selector(changeUser(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(changeUserBtn)
    }
    
    override func viewDidLayoutSubviews() {
        headView.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(80)
        }
        
        touchButton.snp_makeConstraints { (make) in
            make.center.equalTo(view.snp_center)
            make.height.equalTo(view.snp_height).multipliedBy(0.3)
        }
        
        changeUserBtn.snp_makeConstraints { (make) in
            make.bottom.equalTo(view).offset(-30)
            make.centerX.equalTo(view)
        }
    }
    
    //MARK: --action
    func touchIdentfy(sender:UIButton) {
        if !AlTouch.isTouchIdAvailable {
            return
        }
        AlTouch.touchIdentfy { [weak self] (success, error) in
            if success {
                self?.dismissViewControllerAnimated(true, completion: nil)
            }else if error != nil {
                switch Int32(error!.code) {
                case kLAErrorUserFallback:      //点击了输入密码
                    print(error?.code)
                default:break
                }
            }
        }
    }
    
    func changeUser(sender:UIButton) {
        self.dismissViewControllerAnimated(false) {
            UIApplication.sharedApplication().windows[0].rootViewController?.presentViewController(LoginViewController(), animated: true, completion: nil)
        }
    }
}
