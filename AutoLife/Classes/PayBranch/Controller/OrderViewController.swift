//
//  OrderViewController.swift
//  AutoLife
//
//  Created by XuBupt on 16/7/12.
//  Copyright © 2016年 徐成. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    let backgroundView = UIImageView()
    let tableView = UITableView()
    var json = JSON.null
    let layoutArray = ["plateNumber","parkingLot","extanceTime","OutTime","totalTime","currentFee"]
    let titles = ["车牌号","停车场","入场时间","出场时间","停放总时长","实际支付"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "订单已完成"
        backgroundView.image = UIImage(named: "orderBack")?.resizableImageWithCapInsets(UIEdgeInsetsMake(10, 0, 10, 0), resizingMode: .Stretch)
        view.addSubview(backgroundView)
        view.backgroundColor = AlStyle.color.gray_light
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(rightItemAction(_:)))
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSFontAttributeName:AlStyle.font.normal], forState: .Normal)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.scrollEnabled = false
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.frame = CGRectMake(0, 74, AlStyle.size.width, 6 * AlStyle.cellHeight)
        view.addSubview(tableView)
    }
    
    func rightItemAction(sender:AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {
            AppDelegate.shareApplication.parkingVC = nil
        })
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return AlStyle.cellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.cellWithString(indexPath)
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
        cell?.textLabel?.text = self.titles[indexPath.row]
        if let value = json[layoutArray[indexPath.row]].string {
            cell?.detailTextLabel?.text = value
        }
        return cell!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
