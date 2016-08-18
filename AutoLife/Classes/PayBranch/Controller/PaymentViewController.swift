//
//  PaymentViewController.swift
//  AutoLife
//
//  Created by XuBupt on 16/7/9.
//  Copyright © 2016年 徐成. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    private var payInWallet = false
    var selectedIndex = NSIndexPath.init(forRow: 0, inSection: 2)
    let backgroundView = UIImageView()
    let tableView = UITableView()
    let footerView = UIView()
    let footerLabel = UILabel.init()
    let footerBtn = UIButton(type: .Custom)
    var json = JSON.null
    let layoutArray = [["plateNumber","parkingLot","extanceTime","OutTime","totalTime","currentFee"],
                       ["coupon","wallet"]]
    let titles = [["车牌号","停车场","入场时间","出场时间","停放总时长","总费用"],["优惠券","余额支付"],["支付宝支付","微信支付"]]
    let pay = [["zhifubao","weixin"],["支付宝支付","微信支付"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = json["title"].string
        backgroundView.image = UIImage(named: "orderBack")?.resizableImageWithCapInsets(UIEdgeInsetsMake(10, 0, 10, 0), resizingMode: .Stretch)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        if self.navigationController?.viewControllers.count == 1 {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(backPreviousVC(_:)))
        }
        
        view.addSubview(backgroundView)
        view.backgroundColor = AlStyle.color.gray_light
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.scrollEnabled = false
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.frame = CGRectMake(0, 74, AlStyle.size.width, 10 * AlStyle.cellHeight + 20)
        view.addSubview(tableView)
        setFooterView()
    }
    
    func backPreviousVC(sender:UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setFooterView() {
        view.addSubview(footerView)
        footerView.backgroundColor = AlStyle.color.white
        let fee = NSString(string: json["currentFee"].string!).floatValue
        let text = NSMutableAttributedString(string: "合计： \(String.init(format: "%.2f", fee/100))元")
        text.addAttributes([NSForegroundColorAttributeName:UIColor.redColor()], range: NSMakeRange(3, text.length - 3))
        footerLabel.attributedText = text
        view.addSubview(footerLabel)
        footerBtn.setTitle("立即支付", forState: .Normal)
        footerBtn.backgroundColor = UIColor.redColor()
        view.addSubview(footerBtn)
        footerBtn.handleControlEvent(.TouchUpInside) { (sender) in
            let row = self.selectedIndex.row
            let hub = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//            self.view.addSubview(hub)
//            hub.mode = MBProgressHUDMode.CustomView
            hub.labelText = "正在支付"
//            hub.show(true)
            switch row {
            case 0:
                XuAlipay.alipayWithDic(self.json.dictionaryObject, andFinish: { [weak self] (result) in
                    guard let weakSelf = self else {return}
                    weakSelf.confirmCharge()
                    if result["resultStatus"]?.description() == "9000" {
                        hub.hide(true)
                        let orderVC = OrderViewController()
                        orderVC.json = weakSelf.json
                        weakSelf.navigationController?.pushViewController(orderVC, animated: true)
                    }else {
                        hub.labelText = result["memo"]!.description()
                        hub.customView = UIImageView(image: UIImage(named:"wrong"))
                        hub.hide(true, afterDelay: 3)
                    }
                })
            case 1:
                WeiChatPay.doWXPayPost(["order":(self.json.description),"way":"\(self.selectedIndex.row)"], payClosure: {
                    [weak self] (isSuccess) in
                    guard let weakSelf = self else {return}
                    weakSelf.confirmCharge()
                    print(isSuccess)
                    if isSuccess {
                        hub.hide(true)
                        let orderVC = OrderViewController()
                        orderVC.json = weakSelf.json
                        weakSelf.navigationController?.pushViewController(orderVC, animated: true)
                    }else {
                        hub.labelText = "支付失败"
                        hub.customView = UIImageView(image: UIImage(named:"wrong"))
                    }
                    hub.hide(true, afterDelay: 3)
                })
            default:
                print(row)
            }
        }
    }
    
    func confirmCharge() {
        guard let confirmUrl = json["confirmUrl"].string else {return}
        let dic:NSMutableDictionary = [:]
        dic.setObject(json["parkioId"].description, forKey: "parkioId")
        dic.setObject(json["plateNumber"].description, forKey: "plateNumber")
        let date = getCurrentTime()
        dic.setObject(date, forKey: "payTime")
        dic.setObject(date, forKey: "confirmTime")
        dic.setObject("0.01", forKey: "currentFee")
        
        XuAlamofire.postParameters(confirmUrl, parameters: ["info":JSON(dic).description], successWithString: { (re) in
            print(re)
            }) { (error, flag) in
                print(error)
        }
    }
    
    func getCurrentTime() -> String {
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormat.stringFromDate(NSDate())
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return titles.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles[section].count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let array = json["chargeStandard"].arrayObject {
            return CGFloat(array.count) * AlStyle.cellHeight
        }
        return AlStyle.cellHeight
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 2 {
            let cell = WayOfPayTableViewCell(reuseIdentifier: "payC")
            cell.setLeftImage(UIImage.init(named: pay[0][indexPath.row]))
            cell.setLeftText(pay[1][indexPath.row])
            cell.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10)
            cell.setCheck(indexPath.row == selectedIndex.row)
            return cell
        }else if indexPath.section == 1 && indexPath.row == 1{
            let cell = WayOfPayTableViewCell(reuseIdentifier: "payC")
            cell.setLeftText(titles[1][indexPath.row])
            if let subText = json[layoutArray[indexPath.section][indexPath.row]].string {
                cell.setLeftSubText(subText)
            }
            cell.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10)
            return cell
        }
        return self.cellWithString(indexPath)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 2{
            if selectedIndex != indexPath{
                (tableView.cellForRowAtIndexPath(selectedIndex) as! WayOfPayTableViewCell).setCheck(false)
                (tableView.cellForRowAtIndexPath(indexPath) as! WayOfPayTableViewCell).setCheck(true)
                selectedIndex = indexPath
            }
        }else if indexPath.section == 1 && indexPath.row == 1{
            payInWallet = !payInWallet
            (tableView.cellForRowAtIndexPath(indexPath) as! WayOfPayTableViewCell).setCheck(payInWallet)
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
        if indexPath.row != tableView.numberOfRowsInSection(indexPath.section) - 1 {
            let layer = CALayer()
            layer.frame = CGRectMake(15, cell.frame.height - 0.5, cell.frame.width - 30, 0.5)
            layer.backgroundColor = AlStyle.color.gray.CGColor
            cell.layer.addSublayer(layer)
        }
    }
    
    override func viewWillLayoutSubviews() {
        backgroundView.snp_makeConstraints { (make) in
            make.top.equalTo(tableView).offset(-10)
            make.left.right.equalTo(tableView)
            make.bottom.equalTo(tableView).offset(10)
        }
        footerView.snp_makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(50)
        }
        footerLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(footerView)
            make.left.equalTo(footerView).offset(20)
        }
        footerBtn.snp_makeConstraints { (make) in
            make.right.bottom.top.equalTo(footerView)
            make.width.equalTo(view).multipliedBy(0.3)
        }
    }
    
    func cellWithString(indexPath:NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") //as? UniversalTableViewCell
        if cell == nil {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: "cell")
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
            cell?.backgroundColor = UIColor.clearColor()
            cell?.textLabel?.font = AlStyle.font.normal
            cell?.detailTextLabel?.font = AlStyle.font.normal
        }
        cell?.textLabel?.text = self.titles[indexPath.section][indexPath.row]
        if let value = json[layoutArray[indexPath.section][indexPath.row]].string {
            if indexPath == NSIndexPath.init(forRow: 5, inSection: 0) {
                let fee = NSString(string: json["currentFee"].string!).floatValue
                cell?.detailTextLabel?.text = "\(String.init(format: "%.2f", fee/100))元"
            }else {
                cell?.detailTextLabel?.text = value
            }
        }
        return cell!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
