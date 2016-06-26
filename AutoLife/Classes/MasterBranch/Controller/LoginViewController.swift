//
//  LoginViewController.swift
//  AutoLife
//
//  Created by 徐成 on 16/1/14.
//  Copyright © 2016年 徐成. All rights reserved.
//

import UIKit
import Alamofire

enum XuLoginType {
    case DynamicCode,Password,Default
}

class LoginViewController: UIViewController ,UITextFieldDelegate{
    
    var loginType:XuLoginType = XuLoginType.DynamicCode
    lazy var time = 60
    var timer:NSTimer!
    var defaultUser:String?
    
    private var userTextField:UITextField!
    private var pwTextField:UITextField!
    private var dynamicCodeBtn:UIButton!
    private var changeBtn:UIButton!
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
                    guard self.dynamicCodeBtn != nil else {return}
                    dynamicCodeBtn.enabled = true
                    if timer != nil {
                        timer.invalidate()
                        self.timer = nil;time = 60
                        dynamicCodeBtn.setTitle("获取验证码", forState: UIControlState.Normal)
                    }
                }else {
                    let alert = UIAlertController(title: nil, message: "请输入正确的手机号", preferredStyle: UIAlertControllerStyle.Alert)
                    let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            case 12...30:
                if dynamicCodeBtn != nil {
                    dynamicCodeBtn.enabled = false
                }
                textField.text = NSString(string: textField.text!).substringToIndex(11)
                let alert = UIAlertController(title: nil, message: "正确手机号为11位数字，请不要输入第12位！", preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
            default:
                if dynamicCodeBtn != nil {
                    dynamicCodeBtn.enabled = false
                }
                if timer != nil {
                    timer.invalidate()
                    self.timer = nil;time = 60
                    dynamicCodeBtn.setTitle("获取验证码", forState: UIControlState.Normal)
                }
            }
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if timer != nil && !dynamicCodeBtn.enabled && textField == userTextField {
            let alert = UIAlertController(title: "提示", message: "已发送验证码到\(userTextField.text!)，确定重新输入手机号？", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (_) -> Void in
                textField.becomeFirstResponder()
            }))
            alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Default, handler: { (_) -> Void in
                textField.resignFirstResponder()
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
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
            dynamicCodeBtn.setTitle("重新获取验证码", forState: UIControlState.Normal)
            dynamicCodeBtn.enabled = true
        }else {
            dynamicCodeBtn.enabled = false
            dynamicCodeBtn.setTitle("（\(time)）后重发", forState: UIControlState.Normal)
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
    
    //MARK: --initView
    func initDynamicCodeView() {
        let originHeight:CGFloat = 100;let ctrlHeight:CGFloat = 20;let gap:CGFloat = 20
        
        changeBtn = UIButton(type: UIButtonType.Custom)
        changeBtn.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 90, 30, 80, 40)
        changeBtn.titleLabel?.font = AlStyle.font.small
        changeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        changeBtn.setTitleColor(AlStyle.color.blue_light, forState: UIControlState.Normal)
        changeBtn.addTarget(self, action: #selector(LoginViewController.changeWayOfLogin(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(changeBtn)
        
        let imageView:UIImageView = UIImageView(frame: CGRectMake(0, 0, 60, 60))
        imageView.center = CGPointMake(self.view.center.x, originHeight)
        imageView.image = UIImage(named: "logo")
        self.view.addSubview(imageView)
        
        let label = UILabel(frame: CGRectMake(0, originHeight + gap * 2, self.view.frame.width, ctrlHeight))
        label.text = "三十辐共一毂  当其无有车之用"
        label.font = AlStyle.font.normal
        label.textAlignment = NSTextAlignment.Center
        self.view.addSubview(label)
        
        self.userTextField = UITextField(frame: CGRectMake(20, originHeight + ctrlHeight + gap * 3 - 10, CGRectGetWidth(self.view.frame) - 40, 40))
        self.userTextField.keyboardType = UIKeyboardType.NumberPad
        userTextField.keyboardAppearance = UIKeyboardAppearance.Default
        self.userTextField.placeholder = "手机"
        self.userTextField.delegate = self
        self.view.addSubview(self.userTextField)
        
        let line1 = UIView(frame: CGRectMake(20, originHeight + ctrlHeight + gap * 4, CGRectGetWidth(self.view.frame) - 40, 1))
        line1.backgroundColor = AlStyle.color.gray
        self.view.addSubview(line1)
        
        self.pwTextField = UITextField(frame: CGRectMake(20, originHeight + ctrlHeight + gap * 5 - 10, CGRectGetWidth(self.view.frame) - 40, 40))
        self.view.addSubview(self.pwTextField)
        self.pwTextField.delegate = self
        
        let line2 = UIView(frame: CGRectMake(20, originHeight + ctrlHeight + gap * 6, CGRectGetWidth(self.view.frame) - 40, 1))
        line2.backgroundColor = AlStyle.color.gray
        self.view.addSubview(line2)
        
        let textBtn = UIButton(type: UIButtonType.Custom)
        let attributedText = NSMutableAttributedString(string: "登录即代表您已阅读并同意《账户协议》",attributes: [NSForegroundColorAttributeName:UIColor.lightGrayColor(),
            NSFontAttributeName:AlStyle.font.small])
        attributedText.addAttributes([NSForegroundColorAttributeName:AlStyle.color.blue_light], range: NSMakeRange(attributedText.length - 6, 6))
        textBtn.frame = CGRectMake(20, originHeight + ctrlHeight + gap * 6 + 10, CGFloat(attributedText.length) * 12, 15)
        textBtn.setAttributedTitle(attributedText, forState: UIControlState.Normal)
        textBtn.addTarget(self, action: #selector(LoginViewController.showAcProtocol(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(textBtn)
        
        loginBtn = UIButton(type: UIButtonType.System)
        let attributedTitle = NSMutableAttributedString(string: "登 录", attributes: [
            NSForegroundColorAttributeName:UIColor.whiteColor(),
            NSFontAttributeName:XutextSizeNav])
        loginBtn.setAttributedTitle(attributedTitle, forState: UIControlState.Normal)
        loginBtn.frame = CGRectMake(20, originHeight + ctrlHeight + gap * 9, CGRectGetWidth(self.view.frame) - 40, 40)
        loginBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        //loginBtn.enabled = false
        //loginBtn.backgroundColor = AlStyle.color.gray
        loginBtn.backgroundColor = AlStyle.color.blue
        loginBtn.addTarget(self, action: #selector(LoginViewController.loginAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        loginBtn.layer.cornerRadius = 6
        self.view.addSubview(loginBtn)
        
        switch self.loginType {
        case .DynamicCode:
            changeBtn.setTitle("密码登录", forState: UIControlState.Normal)
            
            dynamicCodeBtn = UIButton(type: UIButtonType.Custom)
            dynamicCodeBtn.frame = CGRectMake(CGRectGetWidth(self.view.frame) / 2, originHeight + ctrlHeight + gap * 3 - 10, CGRectGetWidth(self.view.frame) / 2 - 20, 40)
            dynamicCodeBtn.setTitle("获取验证码", forState: UIControlState.Normal)
            dynamicCodeBtn.enabled = false
            dynamicCodeBtn.titleLabel?.font = AlStyle.font.normal
            dynamicCodeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
            dynamicCodeBtn.setTitleColor(AlStyle.color.blue, forState: UIControlState.Normal)
            dynamicCodeBtn.setTitleColor(AlStyle.color.gray, forState: UIControlState.Disabled)
            dynamicCodeBtn.addTarget(self, action: #selector(LoginViewController.getDynamicCode(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(dynamicCodeBtn)
            
            self.pwTextField.keyboardType = UIKeyboardType.NumberPad
            self.pwTextField.placeholder = "验证码"
            
        default:
            changeBtn.setTitle("验证码登录", forState: UIControlState.Normal)
            self.pwTextField.placeholder = "密码"
            self.pwTextField.secureTextEntry = true
        }
    }
    
    func initDefaultView() {
        let originHeight:CGFloat = 100;let ctrlHeight:CGFloat = 20;let gap:CGFloat = 20
        
        changeBtn = UIButton(type: UIButtonType.Custom)
        changeBtn.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 150, 30, 130, 20)
        changeBtn.titleLabel?.font = AlStyle.font.small
        changeBtn.setTitle("使用其他方式登录", forState: UIControlState.Normal)
        changeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        changeBtn.setTitleColor(AlStyle.color.blue_light, forState: UIControlState.Normal)
        changeBtn.addTarget(self, action: #selector(LoginViewController.changeWayOfLogin(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(changeBtn)
        
        let imageView:UIImageView = UIImageView(frame: CGRectMake(0, 0, 60, 60))
        imageView.center = CGPointMake(self.view.center.x, originHeight + gap + 5)
        imageView.image = UIImage(named: "logo")
        self.view.addSubview(imageView)
        
        self.userTextField = UITextField(frame: CGRectMake(20, originHeight + ctrlHeight + gap * 3, CGRectGetWidth(self.view.frame) - 40, ctrlHeight))
        self.userTextField.text = defaultUser
        self.userTextField.textAlignment = NSTextAlignment.Center
        self.userTextField.enabled = false
        self.userTextField.delegate = self
        self.view.addSubview(self.userTextField)
        
        let line1 = UIView(frame: CGRectMake(20, originHeight + ctrlHeight + gap * 7, CGRectGetWidth(self.view.frame) - 40, 1))
        line1.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(line1)
        
        self.pwTextField = UITextField(frame: CGRectMake(20, originHeight + ctrlHeight + gap * 6, CGRectGetWidth(self.view.frame) - 40, ctrlHeight))
        self.pwTextField.keyboardType = UIKeyboardType.NamePhonePad
        self.pwTextField.placeholder = "密码"
        self.pwTextField.delegate = self
        self.pwTextField.secureTextEntry = true
        self.view.addSubview(self.pwTextField)
        
        
        loginBtn = UIButton(type: UIButtonType.System)
        let attributedTitle = NSMutableAttributedString(string: "登 录", attributes: [
            NSForegroundColorAttributeName:UIColor.whiteColor(),
            NSFontAttributeName:XutextSizeNav])
        loginBtn.setAttributedTitle(attributedTitle, forState: UIControlState.Normal)
        loginBtn.frame = CGRectMake(20, originHeight + ctrlHeight + gap * 10, CGRectGetWidth(self.view.frame) - 40, 40)
        loginBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        loginBtn.backgroundColor = AlStyle.color.blue
        loginBtn.addTarget(self, action: #selector(LoginViewController.loginAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        loginBtn.layer.cornerRadius = 6
        self.view.addSubview(loginBtn)
    }
    
}
