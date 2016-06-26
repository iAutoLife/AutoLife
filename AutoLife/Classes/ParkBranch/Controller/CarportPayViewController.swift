//
//  CarportPayViewController.swift
//  AutoLife
//
//  Created by XuBupt on 16/6/22.
//  Copyright © 2016年 徐成. All rights reserved.
//

import UIKit

class CarportPayViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    private var tableView:UITableView!
    private var selectedIndexPath = NSIndexPath(forRow: 0, inSection: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "车位续费"
        tableView = UITableView(frame: CGRectMake(0, 0, AlStyle.size.width, AlStyle.size.height == 667 ? AlStyle.size.height : AlStyle.size.height),style: UITableViewStyle.Grouped)
        self.view.addSubview(tableView)
        XuSetup(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 1 }
        else {
            return 3
        }
    }
    
    let images = ["zhifubao","weixin","visa"]
    let texts = ["支付宝支付","微信支付","我的钱包"]
    let details = ["建议支付宝用户使用","建议微信支付用户使用","余额：0元",]
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        if cell == nil {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: "cell")
            cell?.backgroundColor = UIColor.clearColor()
        }
        if indexPath.section == 0 {
            let text = NSMutableAttributedString(string: "本次支付金额：0.01元")
            text.addAttributes([NSForegroundColorAttributeName:AlStyle.color.blue], range: NSMakeRange(text.length - 5, 4))
            cell?.textLabel?.attributedText = text
        }else {
            cell?.imageView?.image = UIImage(named: images[indexPath.row])
            cell?.textLabel?.text = texts[indexPath.row]
            cell?.detailTextLabel?.text = details[indexPath.row]
            cell?.detailTextLabel?.font = AlStyle.font.small
            if indexPath.row == 0 {
                cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath != selectedIndexPath {
            let cell = tableView.cellForRowAtIndexPath(selectedIndexPath)
            cell?.accessoryType  = UITableViewCellAccessoryType.None
        }
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        selectedIndexPath = indexPath
        switch (indexPath.section,indexPath.row) {
        case (1,1):
            print("pay")
        case (1,2):
            print("weixin")
        default:
            break
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "    支付金额"
        }else {
            return "    请选择支付方式"
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 80
        }
        return 0
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            let view = UIView()
            let button = UIButton(type: .Custom)
            button.backgroundColor = AlStyle.color.blue
            button.setTitle("立即支付", forState: .Normal)
            button.frame = CGRectMake(40, 30, AlStyle.size.width - 80, 40)
            view.addSubview(button)
            button.handleControlEvent(.TouchUpInside, withBlock: { (_) in
                switch self.selectedIndexPath.row {
                case 0:
                    XuAlipay.alipayWithLocalKey({ () -> Void in
                        print("finished")
                    })
                case 1:
                    let hub = MBProgressHUD(view: self.view)
                    self.view.addSubview(hub)
                    hub.show(true)
                    hub.labelText = "正在支付..."
                    hub.hide(true, afterDelay: 3)
                    WeiChatPay.jumpToBizPay()
                case 2:
                    self.presentViewController(Assistant.alertHint("我的钱包", message: "余额不足"), animated: true, completion: nil)
                default:break
                }
            })
            return view
        }
        return nil
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        XutableView(tableView, willDisplayCell: cell, forRowIndexPath: indexPath)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
