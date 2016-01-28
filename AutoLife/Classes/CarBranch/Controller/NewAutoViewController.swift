//
//  NewAutoViewController.swift
//  AutoLife
//
//  Created by 徐成 on 16/1/14.
//  Copyright © 2016年 徐成. All rights reserved.
//

import UIKit

class NewAutoViewController: UIViewController {
    
    @IBOutlet weak var boundsView: UIView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var plateTextField: UITextField!
    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var determineButton: UIButton!
    @IBOutlet weak var checkYesButton: UIButton!
    @IBOutlet weak var checkNoButton: UIButton!
    @IBOutlet weak var provinceBtn: UIButton!
    @IBOutlet weak var engineNumTF: UITextField!
    
    var isNewLogin = false
    private var isOwner = 0
    private var provinceView:ProvincesView!
    
    var brand = ("","") {
        didSet{
            self.brandLabel.text = brand.1
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if isNewLogin {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "跳过", style: UIBarButtonItemStyle.Plain, target: self, action: "skipThisTap:")
        }
        
        provinceBtn.buttonWithLeft("京", right: UIImage(named: "down"))
        provinceBtn.layer.borderColor = XuColorBlueThin.CGColor
        provinceBtn.layer.borderWidth = 1
        provinceBtn.layer.cornerRadius = XuCornerRadius
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: UIBarButtonItemStyle.Plain, target: self, action: "goback:")
        
        boundsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapSuperView:"))
        selectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "chooseBrandTap:"))
        
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([
            NSForegroundColorAttributeName:XuColorBlue,
            NSFontAttributeName:UIFont.systemFontOfSize(XuTextSizeSmall, weight: 2)],
            forState: UIControlState.Normal)
        
        self.navigationItem.title = "添加车辆"
        
        boundsView.layer.borderWidth = 1.0
        boundsView.layer.cornerRadius = 6.0
        boundsView.layer.borderColor = XuColorGrayThin.CGColor
        
        determineButton.layer.cornerRadius = 6.0
        
        checkYesButton.setImage(UIImage(named: "check_off"), forState: UIControlState.Normal)
        self.checkYesButton.setImage(UIImage(named: "check_on"), forState: UIControlState.Selected)
        checkNoButton.setImage(UIImage(named: "check_off"), forState: UIControlState.Normal)
        self.checkNoButton.setImage(UIImage(named: "check_on"), forState: UIControlState.Selected)
        
        self.setTextFieldInputView()
    }
    
    func setTextFieldInputView() {
        let nView = NumberView()
        nView.selectItem = { (nus) in
            self.plateTextField.text! += nus
        }
        plateTextField.inputAccessoryView = nView
    }
    
    func goback(sender:UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tapSuperView(sender:NSObject) {
        self.plateTextField.resignFirstResponder()
        if provinceView != nil {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.provinceView.transform = CGAffineTransformIdentity
                self.provinceView.removeFromSuperview()
                }, completion: { (_) -> Void in
                    self.provinceView = nil
            })
        }
    }
    
    func chooseBrandTap(sender:NSObject) {
        let xhud = MBProgressHUD()
        self.view.addSubview(xhud)
        xhud.show(true)
        XuAlamofire.getJSON(uHeader + "auto/brand.first", success: { (xjson) -> Void in
            let brandVC = BrandViewController()
            self.navigationController?.pushViewController(brandVC, animated: true)
            brandVC.letters = xjson?.object.firstObject as? [String]
            brandVC.setLetter(brandVC.letters!)
            brandVC.brandJSON = xjson![1]
            brandVC.superVC = self
            
            xhud.hide(true)
            }, failed: { error,isTimeOut in
                xhud.labelText = "请求失败"
                xhud.hide(true, afterDelay: 1)
                assert(isTimeOut, "error : \(error)")
        })
    }
    
    func skipThisTap(sender:UIBarButtonItem?) {
        let mapView = MasterViewController()
        let nav = UINavigationController(rootViewController: mapView)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    @IBAction func provinceClicked(sender: UIButton) {
        guard provinceView == nil else {return}
        self.plateTextField.resignFirstResponder()
        self.engineNumTF.resignFirstResponder()
        provinceView = ProvincesView(oy: XuHeight)
        self.view.addSubview(provinceView)
        provinceView.selectItem = { (itemString) in
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.provinceView.transform = CGAffineTransformIdentity
                self.provinceView.removeFromSuperview()
                }, completion: { (_) -> Void in
                    self.provinceView = nil
                    self.plateTextField.becomeFirstResponder()
            })
            if itemString != nil {
                self.provinceBtn.setTitle(itemString!, forState: UIControlState.Normal)
            }
        }
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.provinceView.transform = CGAffineTransformMakeTranslation(0, 15-self.provinceView.frame.height)
            }, completion: nil)
    }

    @IBAction func determainAction(sender: AnyObject) {
        self.plateTextField.resignFirstResponder()
        self.engineNumTF.resignFirstResponder()
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "正在提交";hud.show(true)
        let carLicense = (provinceBtn.titleLabel?.text)! + plateTextField!.text!
        XuAlamofire.postParameters(uHeader + "car/add_info", parameters: ["phone":XuKeyChain.get(XuCurrentUser)!,
            "carLicense":carLicense,"isOwner":isOwner,"carBrand":self.brand.0,"engineNum":"\(engineNumTF.text)"], successWithString: { (result) -> Void in
                if result == "true" {
                    hud.mode = MBProgressHUDMode.CustomView
                    hud.labelText = "提交成功"
                    hud.customView = UIImageView(image: UIImage(named: "check"))
                    XuGCD.after(1000, closure: { () -> Void in
                        //添加成功后跳转
                    })
                }else {
                    hud.labelText = "提交失败"
                }
                hud.hide(true, afterDelay: 1)
            }, failed: { (xError) -> Void in
                print(xError)
                hud.labelText = "提交失败"
                hud.hide(true, afterDelay: 1)
        })
        
    }
    
    @IBAction func checkedClicked(sender: AnyObject) {
        self.plateTextField.resignFirstResponder()
        self.engineNumTF.resignFirstResponder()
        switch sender.tag {
        case 1,2:
            self.checkYesButton.selected = (self.checkYesButton.selected ? false : true)
            self.checkNoButton.selected = false
            isOwner = 1
        default:
            self.checkNoButton.selected = (self.checkNoButton.selected ? false : true)
            self.checkYesButton.selected = false
            isOwner = 0
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
