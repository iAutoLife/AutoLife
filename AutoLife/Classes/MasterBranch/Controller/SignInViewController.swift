//
//  SignInViewController.swift
//  AutoLife
//
//  Created by XuBupt on 16/6/26.
//  Copyright © 2016年 徐成. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController  ,UITextFieldDelegate{

    var loginType:XuLoginType = XuLoginType.DynamicCode
    lazy var time = 60
    var timer:NSTimer!
    var defaultUser:String?
    
    private var changeBtn:UIButton!
    private var logoView = UIImageView()
    private var themeLabel = UILabel()
    private var userTextField = AlTextField()
    private var captchaBtn:UIButton?
    private var pwTextField = AlTextField()
    private var protocolBtn:UIButton?
    private var loginBtn:UIButton!
    
    
    //MARK: --func
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = AlStyle.color.white
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.tapView(_:)))
        self.view.addGestureRecognizer(tap)
        switch loginType {
        case .Default:
            self.initDefaultView()
        default:
            self.initDynamicCodeView()
        }
        userTextField.addTarget(self, action: #selector(LoginViewController.textFieldDidChanged(_:)), forControlEvents: UIControlEvents.EditingChanged)
        pwTextField.addTarget(self, action: #selector(LoginViewController.textFieldDidChanged(_:)), forControlEvents: UIControlEvents.EditingChanged)
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
                    guard self.captchaBtn != nil else {return}
                    captchaBtn?.enabled = true
                    if timer != nil {
                        timer.invalidate()
                        self.timer = nil;time = 60
                        captchaBtn?.setTitle("获取验证码", forState: UIControlState.Normal)
                    }
                }else {
                    let alert = UIAlertController(title: nil, message: "请输入正确的手机号", preferredStyle: UIAlertControllerStyle.Alert)
                    let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            case 12...30:
                if captchaBtn != nil {
                    captchaBtn?.enabled = false
                }
                textField.text = NSString(string: textField.text!).substringToIndex(11)
                let alert = UIAlertController(title: nil, message: "正确手机号为11位数字，请不要输入第12位！", preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
            default:
                if captchaBtn != nil {
                    captchaBtn?.enabled = false
                }
                if timer != nil {
                    timer.invalidate()
                    self.timer = nil;time = 60
                    captchaBtn?.setTitle("获取验证码", forState: UIControlState.Normal)
                }
            }
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //        if timer != nil && !captchaBtn?.enabled && textField == userTextField {
        //            let alert = UIAlertController(title: "提示", message: "已发送验证码到\(userTextField.text!)，确定重新输入手机号？", preferredStyle: UIAlertControllerStyle.Alert)
        //            alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (_) -> Void in
        //                textField.becomeFirstResponder()
        //            }))
        //            alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Default, handler: { (_) -> Void in
        //                textField.resignFirstResponder()
        //            }))
        //            self.presentViewController(alert, animated: true, completion: nil)
        //        }
    }
    
    func saveLoginInfo() {
        XuKeyChain.set(userTextField.text!, forkey: XuCurrentUser)
        
        if XuKeyChain.set(pwTextField.text!, forkey: userTextField.text!) {
            currentUser = userTextField.text!
            if timer != nil {timer.invalidate()}
            let carAdditionVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("NewLicensePlateViewController") as? NewAutoViewController
            carAdditionVC?.isNewLogin = true
            let nav = UINavigationController(rootViewController: carAdditionVC!)
            self.presentViewController(nav, animated: true, completion: nil)
        }
    }
    
    //MARK: --actions
    
    func loginAction(sender:UIButton) {
//        self.presentViewController(MainViewController(), animated: true, completion: nil)
        resignFirstResponders()
        guard userTextField.text != "" && pwTextField.text != "" else {
            self.presentViewController(Assistant.alertHint(nil, message: "手机号与密码不能为空！"), animated: true, completion: nil)
            return}
        if userTextField.text != "" {
            self.saveLoginInfo()
            return
        }
        let xhud = MBProgressHUD();xhud.labelText = "正在登录"
        self.view.addSubview(xhud);xhud.show(true)
        switch loginType {
        case .DynamicCode:
            let url = AlStyle.uHeader + "applogin/message.check"
            XuAlamofire.postParameters(url, parameters: ["p":userTextField.text!,"m":pwTextField.text!],
                                       successWithString: { (xrString) -> Void in
                                        print(xrString)
                                        switch xrString! {
                                        case "false":
                                            xhud.mode = MBProgressHUDMode.Text
                                            xhud.labelText = "验证码错误"
                                        case "true":
                                            xhud.customView = UIImageView(image: UIImage(named: "check"))
                                            xhud.mode = MBProgressHUDMode.CustomView
                                            xhud.labelText = "登录成功"
                                            XuGCD.after(1500, closure: { () -> Void in
                                                self.saveLoginInfo()
                                            })
                                        default:
                                            xhud.hide(true)
                                            self.presentViewController(Assistant.alertHint(nil, message: "数据异常！"), animated: true, completion: nil)
                                        }
                                        xhud.hide(true, afterDelay: 1)
                }, failed: { (xError,isTimeOut) -> Void in
                    let message = isTimeOut ? "请求超时" : "数据错误！"
                    self.presentViewController(Assistant.alertHint(nil, message: message), animated: true, completion: nil)
                    xhud.hide(true)
                    print("login failed!   error:\(xError)")
            })
        default:
            let url = AlStyle.uHeader + "applogin/password"
            XuAlamofire.postParameters(url, parameters: ["p":userTextField.text!,"pwd":pwTextField.text!],
                                       successWithString: { (xrString) -> Void in
                                        print(xrString)
                                        switch xrString! {
                                        case "-2":
                                            xhud.mode = MBProgressHUDMode.Text
                                            xhud.labelText = "数据异常"
                                        case "-1":
                                            xhud.mode = MBProgressHUDMode.Text
                                            xhud.labelText = "账号不存在"
                                        case "0":
                                            xhud.mode = MBProgressHUDMode.Text
                                            xhud.labelText = "密码错误"
                                        case "1":
                                            xhud.customView = UIImageView(image: UIImage(named: "check"))
                                            xhud.mode = MBProgressHUDMode.CustomView
                                            xhud.labelText = "登录成功"
                                            XuGCD.after(1500, closure: { () -> Void in
                                                self.saveLoginInfo()
                                            })
                                        case "2":
                                            self.presentViewController(Assistant.alertHint(nil, message: "此账号未设定密码，请使用验证码登录！"), animated: true, completion: nil)
                                        default:
                                            self.presentViewController(Assistant.alertHint(nil, message: "请求异常！"), animated: true, completion: nil)
                                        }
                                        xhud.hide(true, afterDelay: 1)
                }, failed: { (xError,isTimeOut) -> Void in
                    print("login failed!   error:\(xError)")
            })
        }
    }
    
    func resignFirstResponders() {
        userTextField.resignFirstResponder()
        pwTextField.resignFirstResponder()
    }
    
    func getDynamicCode(sender:UIButton) {
        resignFirstResponders()
        let url = AlStyle.uHeader + "applogin/message.send?p=\(userTextField.text!)"
        XuAlamofire.getString(url, success: { (xString) -> Void in
            print(xString)
            self.pwTextField.text = xString!// as! String
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(LoginViewController.OnTimer(_:)), userInfo: nil, repeats: true)
        }) { (xError,isTimeOut) -> Void in
            print("error   error:\(xError)")
        }
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
            captchaBtn?.setTitle("重新获取验证码", forState: UIControlState.Normal)
            captchaBtn?.enabled = true
        }else {
            captchaBtn?.enabled = false
            captchaBtn?.setTitle("（\(time)）后重发", forState: UIControlState.Normal)
            time -= 1
        }
    }
    
    func tapView(sender:UITapGestureRecognizer) {
        resignFirstResponders()
    }
    
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
            let dynamicAlert = UIAlertAction(title: "验证码登录", style: UIAlertActionStyle.Default, handler: { (_) -> Void in
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
    
    override func viewDidLayoutSubviews() {
        changeBtn.snp_makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-10)
            make.top.equalTo(self.view).offset(AlStyle.algebraConvert(30))
        }
        
        logoView.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view).offset(AlStyle.algebraConvert(80))
            make.width.height.equalTo(AlStyle.algebraConvert(60))
        }
        
        themeLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(logoView)
            make.top.equalTo(logoView.snp_bottom).offset(15)
        }
        
        userTextField.snp_makeConstraints { (make) in
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.top.equalTo(themeLabel.snp_bottom).offset(20)
        }
        
        
        captchaBtn?.snp_makeConstraints(closure: { (make) in
            make.right.equalTo(userTextField)
            make.bottom.equalTo(userTextField)
        })
        
        pwTextField.snp_makeConstraints { (make) in
            make.top.equalTo(userTextField.snp_bottom).offset(10)
            make.left.height.right.equalTo(userTextField)
        }
        
        protocolBtn?.snp_makeConstraints(closure: { (make) in
            make.top.equalTo(pwTextField.snp_bottom).offset(0)
            make.left.equalTo(userTextField)
        })
        
        loginBtn.snp_makeConstraints { (make) in
            make.top.equalTo(pwTextField.snp_bottom).offset(50)
            make.left.right.height.equalTo(userTextField)
            
        }
    }
    
    //MARK: --initView
    func initDynamicCodeView() {
        changeBtn = UIButton(type: UIButtonType.Custom)
        changeBtn.titleLabel?.font = AlStyle.font.small
        changeBtn.setTitleColor(AlStyle.color.blue_light, forState: UIControlState.Normal)
        changeBtn.addTarget(self, action: #selector(changeWayOfLogin(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(changeBtn)
        
        logoView.image = UIImage(named: "logo")
        self.view.addSubview(logoView)
        
        themeLabel.text = "三十辐共一毂  当其无有车之用"
        themeLabel.font = AlStyle.font.normal
        self.view.addSubview(themeLabel)
        
        userTextField.keyboardType = UIKeyboardType.NumberPad
        userTextField.keyboardAppearance = UIKeyboardAppearance.Default
        userTextField.placeholder = "手机"
        userTextField.delegate = self
        userTextField.lineColor = AlStyle.color.gray
        self.view.addSubview(userTextField)
        
        self.view.addSubview(self.pwTextField)
        pwTextField.lineColor = AlStyle.color.gray
        pwTextField.delegate = self
        
        protocolBtn = UIButton(type: UIButtonType.Custom)
        let attributedText = NSMutableAttributedString(string: "登录即代表您已阅读并同意《账户协议》",attributes: [NSForegroundColorAttributeName:UIColor.lightGrayColor(),
            NSFontAttributeName:UIFont.systemFontOfSize(AlStyle.font.small.pointSize, weight: 1.3)])
        attributedText.addAttributes([NSForegroundColorAttributeName:AlStyle.color.blue_light], range: NSMakeRange(attributedText.length - 6, 6))
        protocolBtn!.setAttributedTitle(attributedText, forState: UIControlState.Normal)
        protocolBtn!.addTarget(self, action: #selector(LoginViewController.showAcProtocol(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(protocolBtn!)
        
        loginBtn = UIButton(type: UIButtonType.System)
        let attributedTitle = NSMutableAttributedString(string: "登 录", attributes: [
            NSForegroundColorAttributeName:UIColor.whiteColor(),
            NSFontAttributeName:UIFont.systemFontOfSize(AlStyle.font.nav.pointSize, weight: 2)])
        loginBtn.setAttributedTitle(attributedTitle, forState: UIControlState.Normal)
        loginBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        loginBtn.backgroundColor = AlStyle.color.blue
        loginBtn.addTarget(self, action: #selector(LoginViewController.loginAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        loginBtn.layer.cornerRadius = 6
        self.view.addSubview(loginBtn)
        
        switch self.loginType {
        case .DynamicCode:
            changeBtn.setTitle("密码登录", forState: UIControlState.Normal)
            
            captchaBtn = UIButton(type: UIButtonType.Custom)
            captchaBtn!.setTitle("获取验证码", forState: UIControlState.Normal)
            captchaBtn!.enabled = false
            //            captchaBtn?.frame = CGRectMake(0, 0, AlStyle.font.normal.pointSize * 5, AlStyle.font.normal.pointSize)
            captchaBtn!.titleLabel?.font = AlStyle.font.normal
            captchaBtn!.setTitleColor(AlStyle.color.blue, forState: UIControlState.Normal)
            captchaBtn!.setTitleColor(AlStyle.color.gray, forState: UIControlState.Disabled)
            captchaBtn!.addTarget(self, action: #selector(LoginViewController.getDynamicCode(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(captchaBtn!)
            //            userTextField.rightView = captchaBtn
            //            userTextField.rightViewMode = UITextFieldViewMode.Always
            
            self.pwTextField.keyboardType = UIKeyboardType.NumberPad
            self.pwTextField.placeholder = "验证码"
            
        default:
            changeBtn.setTitle("验证码登录", forState: UIControlState.Normal)
            self.pwTextField.placeholder = "密码"
            self.pwTextField.secureTextEntry = true
        }
    }
    
    func initDefaultView() {
        
        changeBtn = UIButton(type: UIButtonType.Custom)
        changeBtn.titleLabel?.font = AlStyle.font.small
        changeBtn.setTitle("使用其他方式登录", forState: UIControlState.Normal)
        changeBtn.setTitleColor(AlStyle.color.blue_light, forState: UIControlState.Normal)
        changeBtn.addTarget(self, action: #selector(changeWayOfLogin(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(changeBtn)
        
        logoView.image = UIImage(named: "logo")
        self.view.addSubview(logoView)
        
        self.userTextField.text = defaultUser
        self.userTextField.textAlignment = NSTextAlignment.Center
        self.userTextField.enabled = false
        self.userTextField.delegate = self
        self.view.addSubview(self.userTextField)
        
        pwTextField.keyboardType = UIKeyboardType.NamePhonePad
        pwTextField.placeholder = "密码"
        pwTextField.delegate = self
        pwTextField.secureTextEntry = true
        self.view.addSubview(pwTextField)
        
        
        loginBtn = UIButton(type: UIButtonType.System)
        let attributedTitle = NSMutableAttributedString(string: "登 录", attributes: [
            NSForegroundColorAttributeName:UIColor.whiteColor(),
            NSFontAttributeName:UIFont.systemFontOfSize(AlStyle.font.nav.pointSize, weight: 2)])
        loginBtn.setAttributedTitle(attributedTitle, forState: UIControlState.Normal)
        loginBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        loginBtn.backgroundColor = AlStyle.color.blue
        loginBtn.addTarget(self, action: #selector(LoginViewController.loginAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        loginBtn.layer.cornerRadius = 6
        self.view.addSubview(loginBtn)
    }

}
