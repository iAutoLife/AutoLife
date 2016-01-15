//
//  LoginViewController.swift
//  AutoLife
//
//  Created by 徐成 on 16/1/14.
//  Copyright © 2016年 徐成. All rights reserved.
//

import UIKit

enum XuLoginType {
    case DynamicCode,Password,Default
}

class LoginViewController: UIViewController {
    
    var loginType:XuLoginType = XuLoginType.DynamicCode
    lazy var time = 60
    var timer:NSTimer!
    var defaultUser:String?
    
    private var userTextField:UITextField!
    private var pwTextField:UITextField!
    private var dynamicCodeBtn:UIButton!
    private var changeBtn:UIButton!
    private var loginBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = XuColorWhite
        switch loginType {
        case .Default:
            self.initDefaultView()
        default:
            self.initDynamicCodeView()
        }
        userTextField.addTarget(self, action: "textFieldDidChanged:", forControlEvents: UIControlEvents.EditingChanged)
        pwTextField.addTarget(self, action: "textFieldDidChanged:", forControlEvents: UIControlEvents.EditingChanged)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.timer = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: --UITextFieldDidChanged
    func textFieldDidChanged(textField:UITextField) {
        if textField == userTextField {
            switch NSString(string: textField.text!).length {
            case 11:
                if XuRegularExpression.isVaild(textField.text!, fortype: XuRegularType.phone) {
                    guard self.dynamicCodeBtn != nil else {return}
                    dynamicCodeBtn.enabled = true
                    if timer != nil {
                        timer.invalidate()
                        self.timer = nil;time = 60
                        dynamicCodeBtn.setTitle("动态密码", forState: UIControlState.Normal)
                    }
                }else {
                    let alert = UIAlertController(title: nil, message: "请输入正确的手机号", preferredStyle: UIAlertControllerStyle.Alert)
                    let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            case 12...30:
                dynamicCodeBtn.enabled = false
                textField.text = NSString(string: textField.text!).substringToIndex(11)
                let alert = UIAlertController(title: nil, message: "请输入正确的手机号", preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
            default:
                dynamicCodeBtn.enabled = false
            }
        }else {
            if NSString(string: textField.text!).length == 6 {
                loginBtn.enabled = true
                loginBtn.backgroundColor = XuColorBlue
            }else {
                loginBtn.enabled = false
                loginBtn.backgroundColor = XuColorGray
            }
        }
    }
    
    //MARK: --actions
    func changeWayOfLogin(sender:UIButton) {
        switch self.loginType {
        case .DynamicCode:
            let loginVC = LoginViewController()
            loginVC.loginType = XuLoginType.Password
            self.presentViewController(loginVC, animated: true, completion: nil)
            
            let animation = CATransition()
            animation.duration = 1
            animation.type = "pageCurl"
            animation.subtype = kCATransitionFromBottom
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            self.view.window?.layer.addAnimation(animation, forKey: "dynamicCode")
            
        case .Password:
            let loginVC = LoginViewController()
            loginVC.loginType = XuLoginType.DynamicCode
            self.presentViewController(loginVC, animated: true, completion: nil)
            
            let animation = CATransition()
            animation.duration = 1
            animation.type = "pageUnCurl"
            animation.subtype = kCATransitionFromBottom
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            self.view.window?.layer.addAnimation(animation, forKey: "password")
            
        case .Default:
            let actionSheet = UIAlertController(title: nil, message: "其他登录方式", preferredStyle: UIAlertControllerStyle.ActionSheet)
            let dynamicAlert = UIAlertAction(title: "动态密码登录", style: UIAlertActionStyle.Default, handler: { (_) -> Void in
                let loginVC = LoginViewController()
                loginVC.loginType = XuLoginType.DynamicCode
                self.presentViewController(loginVC, animated: true, completion: nil)
            })
            
            let passwordAlert = UIAlertAction(title: "使用密码登录", style: UIAlertActionStyle.Default, handler: { (_) -> Void in
                let loginVC = LoginViewController()
                loginVC.loginType = XuLoginType.Password
                self.presentViewController(loginVC, animated: true, completion: nil)
            })
            
            let cancelAlert = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (_) -> Void in
                
            })
            actionSheet.addAction(dynamicAlert)
            actionSheet.addAction(passwordAlert)
            actionSheet.addAction(cancelAlert)
            self.presentViewController(actionSheet, animated: true, completion: nil)
        }
    }
    
    func loginAction(sender:UIButton) {
        UITextField.appearance().resignFirstResponder()
        
        if userTextField.text != "" {
            print(KeyChain.set(userTextField.text!, forkey: XuCurrentUser))
        }
        
        if KeyChain.set(pwTextField.text!, forkey: userTextField.text!) {
            currentUser = userTextField.text!
            if timer != nil {timer.invalidate()}
            let carAdditionVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("NewLicensePlateViewController") as? NewAutoViewController
            carAdditionVC?.isNewLogin = true
            let nav = UINavigationController(rootViewController: carAdditionVC!)
            self.presentViewController(nav, animated: true, completion: nil)
        }
    }
    
    func getDynamicCode(sender:UIButton) {
        UITextField.appearance().resignFirstResponder()
        userTextField.resignFirstResponder()
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "OnTimer:", userInfo: nil, repeats: true)
    }
    
    func showAcProtocol(sender:UIButton) {
        let acProtocol = AgreementViewController()
        acProtocol.previousVC = self
        self.presentViewController(UINavigationController(rootViewController: acProtocol), animated: true, completion: nil)
    }
    
    func OnTimer(timer:NSTimer) {
        if time == 0 {
            timer.invalidate()
            self.timer = nil;time = 60
            dynamicCodeBtn.setTitle("重新获取动态密码", forState: UIControlState.Normal)
            dynamicCodeBtn.enabled = true
        }else {
            dynamicCodeBtn.enabled = false
            dynamicCodeBtn.setTitle("已发送（\(--time)）", forState: UIControlState.Normal)
        }
    }
    
    //MARK: --initView
    func initDynamicCodeView() {
        let originHeight:CGFloat = 100;let ctrlHeight:CGFloat = 20;let gap:CGFloat = 20
        
        changeBtn = UIButton(type: UIButtonType.Custom)
        changeBtn.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 100, 30, 80, 20)
        changeBtn.titleLabel?.font = UIFont.systemFontOfSize(XuTextSizeSmall)
        changeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        changeBtn.setTitleColor(XuColorBlueThin, forState: UIControlState.Normal)
        changeBtn.addTarget(self, action: "changeWayOfLogin:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(changeBtn)
        
        let imageView:UIImageView = UIImageView(frame: CGRectMake(0, 0, 60, 60))
        imageView.center = CGPointMake(self.view.center.x, originHeight)
        imageView.image = UIImage(named: "logo")
        self.view.addSubview(imageView)
        
        let label = UILabel(frame: CGRectMake(0, originHeight + gap * 2, self.view.frame.width, ctrlHeight))
        label.text = "三十辐共一毂  当其无有车之用"
        label.font = UIFont.systemFontOfSize(XuTextSizeMiddle)
        label.textAlignment = NSTextAlignment.Center
        self.view.addSubview(label)
        
        self.userTextField = UITextField(frame: CGRectMake(20, originHeight + ctrlHeight + gap * 3, CGRectGetWidth(self.view.frame) - 40, ctrlHeight))
        self.userTextField.keyboardType = UIKeyboardType.DecimalPad
        self.userTextField.placeholder = "手机"
        self.view.addSubview(self.userTextField)
        
        let line1 = UIView(frame: CGRectMake(20, originHeight + ctrlHeight + gap * 4, CGRectGetWidth(self.view.frame) - 40, 1))
        line1.backgroundColor = XuColorGray
        self.view.addSubview(line1)
        
        self.pwTextField = UITextField(frame: CGRectMake(20, originHeight + ctrlHeight + gap * 5, CGRectGetWidth(self.view.frame) - 40, ctrlHeight))
        self.view.addSubview(self.pwTextField)
        
        let line2 = UIView(frame: CGRectMake(20, originHeight + ctrlHeight + gap * 6, CGRectGetWidth(self.view.frame) - 40, 1))
        line2.backgroundColor = XuColorGray
        self.view.addSubview(line2)
        
        let textBtn = UIButton(type: UIButtonType.Custom)
        let attributedText = NSMutableAttributedString(string: "登录即代表您已阅读并同意《账户协议》",attributes: [NSForegroundColorAttributeName:UIColor.lightGrayColor(),
            NSFontAttributeName:UIFont.systemFontOfSize(XuTextSizeSmall, weight: 1.3)])
        attributedText.addAttributes([NSForegroundColorAttributeName:XuColorBlueThin], range: NSMakeRange(attributedText.length - 6, 6))
        textBtn.frame = CGRectMake(20, originHeight + ctrlHeight + gap * 6 + 10, CGFloat(attributedText.length) * 12, 15)
        textBtn.setAttributedTitle(attributedText, forState: UIControlState.Normal)
        textBtn.addTarget(self, action: "showAcProtocol:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(textBtn)
        
        loginBtn = UIButton(type: UIButtonType.System)
        let attributedTitle = NSMutableAttributedString(string: "登 录", attributes: [
            NSForegroundColorAttributeName:UIColor.whiteColor(),
            NSFontAttributeName:UIFont.systemFontOfSize(XutextSizeNav, weight: 2)])
        loginBtn.setAttributedTitle(attributedTitle, forState: UIControlState.Normal)
        loginBtn.frame = CGRectMake(20, originHeight + ctrlHeight + gap * 9, CGRectGetWidth(self.view.frame) - 40, 40)
        loginBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        //loginBtn.enabled = false
        loginBtn.backgroundColor = XuColorGray
        loginBtn.addTarget(self, action: "loginAction:", forControlEvents: UIControlEvents.TouchUpInside)
        loginBtn.layer.cornerRadius = 6
        self.view.addSubview(loginBtn)
        
        switch self.loginType {
        case .DynamicCode:
            changeBtn.setTitle("密码登录", forState: UIControlState.Normal)
            
            dynamicCodeBtn = UIButton(type: UIButtonType.Custom)
            dynamicCodeBtn.frame = CGRectMake(CGRectGetWidth(self.view.frame) / 2, originHeight + ctrlHeight + gap * 3, CGRectGetWidth(self.view.frame) / 2 - 20, 20)
            dynamicCodeBtn.setTitle("动态密码", forState: UIControlState.Normal)
            dynamicCodeBtn.enabled = false
            dynamicCodeBtn.titleLabel?.font = UIFont.systemFontOfSize(XuTextSizeMiddle)
            dynamicCodeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
            dynamicCodeBtn.setTitleColor(XuColorBlue, forState: UIControlState.Normal)
            dynamicCodeBtn.setTitleColor(XuColorGray, forState: UIControlState.Disabled)
            dynamicCodeBtn.addTarget(self, action: "getDynamicCode:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(dynamicCodeBtn)
            
            self.pwTextField.keyboardType = UIKeyboardType.NumberPad
            self.pwTextField.placeholder = "动态密码"
            //pwTextField.inputView = XuPickerView(style: XuPickerStyle.CityAndArea)
            
        default:
            changeBtn.setTitle("动态密码登录", forState: UIControlState.Normal)
            self.pwTextField.placeholder = "密码"
        }
    }
    
    func initDefaultView() {
        let originHeight:CGFloat = 100;let ctrlHeight:CGFloat = 20;let gap:CGFloat = 20
        
        changeBtn = UIButton(type: UIButtonType.Custom)
        changeBtn.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 150, 30, 130, 20)
        changeBtn.titleLabel?.font = UIFont.systemFontOfSize(XuTextSizeSmall)
        changeBtn.setTitle("使用其他方式登录", forState: UIControlState.Normal)
        changeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        changeBtn.setTitleColor(XuColorBlueThin, forState: UIControlState.Normal)
        changeBtn.addTarget(self, action: "changeWayOfLogin:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(changeBtn)
        
        let imageView:UIImageView = UIImageView(frame: CGRectMake(0, 0, 60, 60))
        imageView.center = CGPointMake(self.view.center.x, originHeight + gap + 5)
        imageView.image = UIImage(named: "logo")
        self.view.addSubview(imageView)
        
        self.userTextField = UITextField(frame: CGRectMake(20, originHeight + ctrlHeight + gap * 3, CGRectGetWidth(self.view.frame) - 40, ctrlHeight))
        self.userTextField.text = defaultUser
        self.userTextField.textAlignment = NSTextAlignment.Center
        self.userTextField.enabled = false
        self.view.addSubview(self.userTextField)
        
        let line1 = UIView(frame: CGRectMake(20, originHeight + ctrlHeight + gap * 7, CGRectGetWidth(self.view.frame) - 40, 1))
        line1.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(line1)
        
        self.pwTextField = UITextField(frame: CGRectMake(20, originHeight + ctrlHeight + gap * 6, CGRectGetWidth(self.view.frame) - 40, ctrlHeight))
        self.pwTextField.keyboardType = UIKeyboardType.NamePhonePad
        self.pwTextField.placeholder = "密码"
        self.view.addSubview(self.pwTextField)
        
        
        loginBtn = UIButton(type: UIButtonType.System)
        let attributedTitle = NSMutableAttributedString(string: "登 录", attributes: [
            NSForegroundColorAttributeName:UIColor.whiteColor(),
            NSFontAttributeName:UIFont.systemFontOfSize(XutextSizeNav, weight: 2)])
        loginBtn.setAttributedTitle(attributedTitle, forState: UIControlState.Normal)
        loginBtn.frame = CGRectMake(20, originHeight + ctrlHeight + gap * 10, CGRectGetWidth(self.view.frame) - 40, 40)
        loginBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        loginBtn.backgroundColor = XuColorBlue
        loginBtn.addTarget(self, action: "loginAction:", forControlEvents: UIControlEvents.TouchUpInside)
        loginBtn.layer.cornerRadius = 6
        self.view.addSubview(loginBtn)
    }
    
}
