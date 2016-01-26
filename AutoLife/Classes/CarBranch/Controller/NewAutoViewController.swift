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
    
    var isNewLogin = false
    
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
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: UIBarButtonItemStyle.Plain, target: self, action: "goback:")
        
        let chooseBrandTap = UITapGestureRecognizer(target: self, action: "chooseBrandTap:")
        selectView.addGestureRecognizer(chooseBrandTap)
        
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
    }
    
    func goback(sender:UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
            }, failed: { error in
                xhud.labelText = "请求失败"
                xhud.hide(true, afterDelay: 1)
                print("error : \(error)")
        })
    }
    
    func skipThisTap(sender:UIBarButtonItem?) {
        let mapView = MasterViewController()
        let nav = UINavigationController(rootViewController: mapView)
        self.presentViewController(nav, animated: true, completion: nil)
    }

    @IBAction func determainAction(sender: AnyObject) {
        if isNewLogin {
            self.skipThisTap(nil)
        }else {
//            XuAlamofire.postParameters(uHeader + "", parameters: ["phone":XuKeyChain.get(XuCurrentUser)!,
//                ], reString: { (result) -> Void in
//                
//                }, failed: { (xError) -> Void? in
//                    print(xError)
//            })
        }
    }
    
    @IBAction func checkedClicked(sender: AnyObject) {
        switch sender.tag {
        case 1,2:
            self.checkYesButton.selected = (self.checkYesButton.selected ? false : true)
            self.checkNoButton.selected = false
        default:
            self.checkNoButton.selected = (self.checkNoButton.selected ? false : true)
            self.checkYesButton.selected = false
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
