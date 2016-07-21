//
//  HomeViewController.swift
//  iAutoLife
//
//  Created by XuBupt on 16/4/25.
//  Copyright © 2016年 xubupt218. All rights reserved.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    var coverView:UIImageView!
    var weatherLabel:UILabel!
    var mainView:CollectionView!
    private let gap = AlStyle.algebraConvert(7)
    private var locationLabel = UILabel()
    private var label1 = UILabel()
    private var label2 = UILabel()
    private var messageView = FeatureView()
    private var violationView = FeatureView()
    private var payView = FeatureView()
    private var carportView = FeatureView()
    private var parkView = FeatureView()
    private var adView = UIImageView()
    private var functionView = FuctionView()
    
//    private var payButton:AlButton!
//    private var cameraButton:AlButton!
    private var assistView:CollectionView!
    
    private var alpha:CGFloat = 0
    private var tintColor:UIColor = UIColor()
    private var titleTextAttributes:[String : AnyObject]?
    
    //MARK: --loadviews
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setNavStyle()
        self.loadSubviews()
        self.touchEvent()
    }
    
    override func viewWillAppear(animated: Bool) {
        let phone = XuKeyChain.get(XuCurrentUser)
        if phone != nil && phone != "" {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "分享", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(leftItemAction(_:)))
        }else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(leftItemAction(_:)))
        }
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName:AlStyle.font.normal], forState: .Normal)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func setNavStyle() {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.subviews[0].alpha = 0
        tintColor = self.navigationController!.navigationBar.tintColor
        titleTextAttributes = self.navigationController!.navigationBar.titleTextAttributes
        self.navigationController?.navigationBar.tintColor = AlStyle.color.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:AlStyle.font.nav,NSForegroundColorAttributeName:AlStyle.color.white]
        self.navigationItem.title = "i车生活"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(rightItemAction(_:)))
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSFontAttributeName:AlStyle.font.normal], forState: .Normal)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
       
        self.view.backgroundColor = AlStyle.color.gray_light
    }
    
    func loadSubviews() {
        coverView = UIImageView.init()
        coverView.image = UIImage(named: "cover")
        self.view.addSubview(coverView)
        
        weatherLabel = UILabel.init()
        weatherLabel.text = "2-21℃  晴 轻霾133"
        weatherLabel.font = AlStyle.font.normal
        print(AlStyle.font.normal.pointSize)
        self.view.addSubview(weatherLabel)
        
        mainView = CollectionView(texts: ["洗车","换轮胎","保养维修","服务中心"], images: ["car_wash","tyre","repair","service"])
        mainView.setLayout(0)
        self.view.addSubview(mainView)
        
        self.limitNumber()
        self.setLimit()
        
        messageView.subColor = UIColor.redColor()
        self.view.addSubview(messageView)
        self.view.addSubview(violationView)
        violationView.normal(title: "违章", andText: "不知道")
        
        let pay = NSMutableAttributedString(string: "支付注册有礼")
        pay.addAttributes([NSFontAttributeName:AlStyle.font.normal,NSForegroundColorAttributeName:AlStyle.color.blue_dark], range: NSMakeRange(0, 2))
        pay.addAttributes([NSFontAttributeName:AlStyle.font.smallest,NSForegroundColorAttributeName:AlStyle.color.green_dark], range: NSMakeRange(2, pay.length - 2))
        payView.normalAttributed(title: pay, andText: "因为信用 所以简单")
        self.view.addSubview(payView)
        payView.clicked = {
        }
        
        self.view.addSubview(carportView)
        carportView.normal(title: "我的车位", andText: "因为分享 所以收益")
        
        self.view.addSubview(parkView)
        parkView.normal(title: "停车状态", andText: "随我停车 简单方便")
        parkView.clicked = { () in
            if let parkingVC = AppDelegate.shareApplication.parkingVC {
                self.presentViewController(UINavigationController.init(rootViewController: parkingVC), animated: true, completion: nil)
            }
        }
        
        assistView = CollectionView(texts: ["扫描支付","车位拍照"], images: ["scan","camera"])
        assistView.setLayout(6)
        self.view.addSubview(assistView)
        
        adView.image = UIImage(named: "ad")
        self.view.addSubview(adView)
        
        functionView.closureOfAction = {
            self.presentViewController(UINavigationController(rootViewController: MasterViewController()), animated: true, completion: nil)
        }
        self.view.addSubview(functionView)
    }
    
    override func viewDidLayoutSubviews() {
               
        coverView.snp_makeConstraints { (make) in
            make.height.equalTo(self.view).multipliedBy(0.3)
            make.top.left.right.equalTo(self.view).offset(0)
        }
        
        weatherLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.view).offset(10)
            make.top.equalTo(coverView.snp_bottom).offset(gap)
        }

        mainView.snp_makeConstraints { (make) in
            make.top.equalTo(weatherLabel.snp_bottom).offset(gap).priorityHigh()
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.height.equalTo(coverView).multipliedBy(0.45)
        }
        
        locationLabel.snp_makeConstraints { (make) in
            make.right.equalTo(label1.snp_left).offset(-4)
            make.top.equalTo(label2)
            make.height.equalTo(label2)
            make.width.equalTo(AlStyle.font.normal.lineHeight * CGFloat(NSString(string:locationLabel.text!).length))
        }
        
        label2.snp_makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-10)
            make.top.equalTo(coverView.snp_bottom).offset(5)
            make.width.equalTo(AlStyle.font.normal.pointSize)
            make.height.equalTo(AlStyle.font.normal.lineHeight + 2)
        }
        
        label1.snp_makeConstraints { (make) in
            make.right.equalTo(label2.snp_left).offset(-2)
            make.top.equalTo(label2)
            make.width.equalTo(label2)
            make.height.equalTo(label2)
        }
        
        messageView.snp_makeConstraints { (make) in
            make.top.equalTo(mainView.snp_bottom).offset(gap)
            make.left.equalTo(mainView)
            make.width.equalTo(mainView).multipliedBy(0.23)
            make.height.equalTo(mainView).multipliedBy(0.49)
        }
        
        violationView.snp_makeConstraints { (make) in
            make.left.equalTo(messageView.snp_right).offset(gap)
            make.width.height.top.equalTo(messageView)
        }
        
        payView.snp_makeConstraints { (make) in
            make.top.equalTo(messageView.snp_bottom).offset(gap)
            make.left.equalTo(mainView)
            make.right.equalTo(violationView)
            make.height.equalTo(messageView)
        }
        
        carportView.snp_makeConstraints { (make) in
            make.top.equalTo(payView.snp_bottom).offset(gap)
            make.left.equalTo(mainView)
            make.right.equalTo(violationView)
            make.height.equalTo(messageView)
        }
        
        parkView.snp_makeConstraints { (make) in
            make.top.equalTo(carportView.snp_bottom).offset(gap)
            make.left.equalTo(mainView)
            make.right.equalTo(violationView)
            make.height.equalTo(messageView)
        }
        
        assistView.snp_makeConstraints { (make) in
            make.top.equalTo(carportView)
            make.left.equalTo(parkView.snp_right).offset(gap)
            make.bottom.equalTo(parkView)
            make.width.equalTo(messageView).priorityLow()
            make.right.equalTo(mainView)
        }
        
        adView.snp_makeConstraints { (make) in
            make.top.equalTo(parkView.snp_bottom).offset(gap)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-44)
        }
        
        functionView.snp_makeConstraints { (make) in
            make.top.equalTo(messageView)
            make.left.equalTo(violationView.snp_right).offset(gap)
            make.bottom.equalTo(payView.snp_bottom)
            make.right.equalTo(mainView)
        }
    }
    
    //MARK: --action
    func leftItemAction(sender:UIBarButtonItem) {
        print(sender.title)
        if sender.title == "注册" {
            let nav = UINavigationController(rootViewController: LoginViewController())
            self.showViewController(nav, sender: nil)
        }
    }

    func rightItemAction(sender:UIBarButtonItem) {
        self.presentViewController(TouchViewController(), animated: true, completion: nil)
    }
    
    func touchEvent() {
        messageView.clicked = { [unowned self]() in
            let v = UIViewController()
            v.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(v, animated: true)
        }
    }
    
    func setLimit() {
        locationLabel.text = "北京"
        label1.text = "0"
        label2.text = "5"
    }
    
    //MARK: --customView
    func limitNumber() {
        self.view.addSubview(label2)
        label2.cornerBorder(AlStyle.cornerRadius, font: AlStyle.font.normal)
        
        self.view.addSubview(label1)
        label1.cornerBorder(AlStyle.cornerRadius, font: AlStyle.font.normal)
        
        self.view.addSubview(locationLabel)
        locationLabel.cornerBorder(AlStyle.cornerRadius, font: AlStyle.font.normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class FuctionView: UIView {
    private var carportButton = UIButton(type: .Custom)
    private var chargeButton = UIButton(type: .Custom)
    
    var closureOfAction : (() -> Void)?
    
    init() {
        super.init(frame:CGRectZero)
        self.backgroundColor = UIColor(red: 240/255, green: 241/255, blue: 186/255, alpha: 1)
        layer.cornerRadius = AlStyle.cornerRadius
        layer.shadowColor = AlStyle.color.gray.CGColor
        layer.shadowOffset = CGSizeMake(1.1, 1.1)
        layer.shadowOpacity = 1
        
        carportButton.setAttributedTitle(attributedString(" 找车位 附近停车场39个"), forState: UIControlState.Normal)
        carportButton.setImage(UIImage(named: "park"), forState: .Normal)
        addSubview(carportButton)
        carportButton.addTarget(self, action: #selector(showMap(_:)), forControlEvents: .TouchUpInside)
        
        chargeButton.setAttributedTitle(attributedString(" 加油站 附近加油站17个"), forState: UIControlState.Normal)
        chargeButton.setImage(UIImage(named: "fuel"), forState: .Normal)
        addSubview(chargeButton)
        chargeButton.addTarget(self, action: #selector(showMap(_:)), forControlEvents: .TouchUpInside)
    }
    
    override func layoutSubviews() {
        carportButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self.snp_centerY).offset(-3)
            make.width.equalTo(self)
        }
        
        chargeButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self.snp_centerY).offset(3)
            make.width.equalTo(carportButton)
        }
    }
    
    func attributedString(string:String) -> NSAttributedString {
        let AttributeString = NSMutableAttributedString(string: string)
        AttributeString.addAttributes([NSFontAttributeName:AlStyle.font.normal,NSForegroundColorAttributeName:AlStyle.color.blue_dark], range: NSMakeRange(0, 4))
        AttributeString.addAttributes([NSFontAttributeName:AlStyle.font.smallest,NSForegroundColorAttributeName:AlStyle.color.gray], range: NSMakeRange(5, AttributeString.length - 5))
        AttributeString.addAttributes([NSFontAttributeName:AlStyle.font.normal,NSForegroundColorAttributeName:UIColor.redColor()], range: NSMakeRange(10, AttributeString.length - 11))
        return AttributeString
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: --event action
    func showMap(sender:UIButton) {
        self.closureOfAction?()
    }
}
