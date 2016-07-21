//
//  ParkingViewController.swift
//  AutoLife
//
//  Created by XuBupt on 16/7/7.
//  Copyright © 2016年 徐成. All rights reserved.
//

import UIKit



class ParkingViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    var json:JSON = JSON.null
    private var tableView:UITableView!
    private var chTexts = [["驶入时间","当前费用",],["停车场","停车位","收费标准"],["在线支付状态","可用优惠券"]]
    private let keys = [["extanceTime","currentFee"],["parkingLot","parkingPort","chargeStandard"],
                        ["payState","coupon"]]
    private var carportImageView:UIImageView?
    private var carportImage:UIImage? {
        didSet{
            guard carportImageView != nil else {return}
            carportImageView?.image = carportImage
        }
    }
    
    private var parkingJSON = JSON.null
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        parkingJSON = json["master"]
        print(parkingJSON)
        self.title = parkingJSON["plateNumber"].string
        
        tableView = UITableView(frame: CGRectMake(0, 0, AlStyle.size.width, AlStyle.size.height + 10),style: UITableViewStyle.Grouped)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        if self.navigationController?.viewControllers.count == 1 {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(backPreviousVC(_:)))
        }
        self.view.addSubview(tableView)
        XuSetup(tableView)
        tableView.sectionHeaderHeight = 20
        tableView.dataSource = self
        tableView.delegate = self
        self.timingView()
    }
    
    func backPreviousVC(sender:UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: --UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.chTexts.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chTexts[section].count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return AlStyle.cellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let object = parkingJSON[keys[indexPath.section][indexPath.row]]
        switch object.object {
        case is String:
            return self.cellWithString(indexPath)
        case is Bool:
            var cell = tableView.dequeueReusableCellWithIdentifier("cell1") as? UniversalTableViewCell
            if cell == nil {
                cell = UniversalTableViewCell(universalStyle: UniversalCellStyle.RightSwitch, reuseIdentifier: "cell1")
                cell?.backgroundColor = UIColor.clearColor()
                cell?.selectionStyle = UITableViewCellSelectionStyle.None
            }
            cell?.leftLabelText = self.chTexts[indexPath.section][indexPath.row]
            cell?.rSwitchState = object.bool!
            if indexPath.section == 0 {cell?.leftShift = 120}
            cell?.rightSwitchChanged = { (boolValue) in
                print(boolValue)
            }
            return cell!
        case is NSArray:
            var cell = tableView.dequeueReusableCellWithIdentifier("cell2") as? ArrayTBCell
            if cell == nil {
                cell = ArrayTBCell(reuseIdentifier: "cell2")
                cell?.backgroundColor = UIColor.clearColor()
                cell?.selectionStyle = UITableViewCellSelectionStyle.None
            }
            cell?.title = self.chTexts[indexPath.section][indexPath.row]
            cell?.xarray = object.object as! NSArray
            return cell!
            
        default:return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == self.chTexts.count - 1 {
            return 150
        }
        return 0
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRectMake(0,0,AlStyle.size.width,150))
        let alertButton = UIButton(type: UIButtonType.System)
        alertButton.setup("警 报", fontsize: AlStyle.font.normal.pointSize, fontColor: UIColor.whiteColor(), bkColor: AlStyle.color.blue)
        alertButton.center = CGPointMake(40, 30);view.addSubview(alertButton)
        alertButton.handleControlEvent(UIControlEvents.TouchUpInside) { (_) -> Void in
            let alert = UIAlertController(title: "这是一个警报", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        let payBtn = UIButton.init(type: .Custom)
        payBtn.setTitle("缴费离场", forState: .Normal)
        payBtn.titleLabel?.font = AlStyle.font.normal
        payBtn.backgroundColor = AlStyle.color.blue
        payBtn.layer.cornerRadius = AlStyle.cornerRadius
        payBtn.addTarget(self, action: #selector(payNow(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(payBtn)
        payBtn.snp_makeConstraints { (make) in
            make.right.equalTo(view).offset(-10)
            make.top.equalTo(view).offset(20)
            make.height.equalTo(AlStyle.font.big.pointSize + 5)
            make.width.equalTo(AlStyle.font.big.pointSize * 4 + 20)
        }
        let label = UILabel.init()
        label.text = "缴费后15min内离场免费"
        label.textColor = UIColor.redColor()
        label.font = AlStyle.font.small
        view.addSubview(label)
        label.snp_makeConstraints { (make) in
            make.right.equalTo(payBtn)
            make.top.equalTo(payBtn.snp_bottom).offset(5)
        }
        return view
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        XutableView(tableView, willDisplayCell: cell, forRowIndexPath: indexPath)
    }
    
    //MARK: --XuCameraDelegate
    func XuCameraDidPickImage(image: UIImage) {
        print(image.size)
        self.carportImage = image
    }
    
    func XuCameraDidCancel() {
    }
    
    //MARK: --ControllerAction
    func showMessageView(sender:UIBarButtonItem) {
        let messageVC = MessageViewController()
        self.navigationController?.pushViewController(messageVC, animated: true)
    }
    
    func timingView(){
        let view = UIImageView(frame: CGRectMake(10, 35, 120, 50))
        view.image = UIImage(named: "timing")
        view.layer.cornerRadius = AlStyle.cornerRadius
        self.tableView.addSubview(view)
        if (UIDevice.currentDevice().systemVersion as AnyObject).floatValue >= 8.0 {
            self.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        }
    }
    
    func cellWithString(indexPath:NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as? UniversalTableViewCell
        if cell == nil {
            cell = UniversalTableViewCell(universalStyle: UniversalCellStyle.RightLabel, reuseIdentifier: "cell")
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
            cell?.backgroundColor = UIColor.clearColor()
        }
        cell?.leftLabelText = self.chTexts[indexPath.section][indexPath.row]
        if let value = parkingJSON[keys[indexPath.section][indexPath.row]].string {
            cell?.rightLabelText = value
        }else {
            print(parkingJSON[keys[indexPath.section][indexPath.row]])
        }
        if indexPath.section == 0 {cell?.leftShift = 120}
        if indexPath == NSIndexPath(forRow: 1, inSection: 1) {
            cell?.initRightButton()
            cell?.rightButtonTitle = "车位拍照"
            cell?.rightButtonClicked = { () in
                print("click cheweipaizhao")
            }
        }
        return cell!
    }
    
    func payNow(sender:UIButton) {
        let url = AlStyle.uHeader + json["branch"]["nextURL"].string!
        print(url)
        XuAlamofire.postParameters(url, parameters: ["order":parkingJSON.description], successWithJSON: { (json) in
            print(json)
            let paymentVC = PaymentViewController()
            paymentVC.json = json!
            self.navigationController?.pushViewController(paymentVC, animated: true)
            }) { (error, flag) -> Void? in
                print(error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
