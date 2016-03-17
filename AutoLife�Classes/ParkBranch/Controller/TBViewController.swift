//
//  TBViewController.swift
//  AutoLife
//
//  Created by xubupt218 on 16/3/8.
//  Copyright © 2016年 徐成. All rights reserved.
//

import UIKit

class TBViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    private var tableView:UITableView!
    var parkInfo = [["停车场","车位地址","车位编号","车位性质","租赁方式","租赁起始日","租赁截止日","年费"],["枫蓝国际停车场","北京市海淀区西直门北大街","B1026","租赁","年租","2015/03/21","2016/03/20","¥0.01"]]
    var privileges = [["优惠券","商家代金券"],["暂无可用优惠券","暂无可用代金券"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "车位续费"
        tableView = UITableView(frame: CGRectMake(0, 0, XuWidth, XuHeight == 667 ? XuHeight : XuHeight - 40),style: UITableViewStyle.Grouped)
        self.view.addSubview(tableView)
        XuSetup(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        
        let vview = UIView(frame: CGRectMake(0,XuHeight - 50,XuWidth,50))
        vview.backgroundColor = XuColorWhite
        self.view.addSubview(vview)
        let label = UILabel(frame: CGRectMake(10,0,200,50))
        label.text = "总计¥0.01";label.font = UIFont.systemFontOfSize(17, weight: 2)
        label.textColor = UIColor(red: 10/255, green: 36/255, blue: 0, alpha: 1)
        vview.addSubview(label)
        let btn = UIButton(frame: CGRectMake(XuWidth * 0.618,0,XuWidth * 0.382,50))
        btn.backgroundColor = UIColor(red: 241/255, green: 83/255, blue: 83/255, alpha: 1)
        btn.setTitle("确认", forState: UIControlState.Normal)
        vview.addSubview(btn)
        btn.handleControlEvent(.TouchUpInside) { (_) -> Void in
            XuAlipay.alipayWithLocalKey({ () -> Void in
                print("finish")
                self.navigationController?.popViewControllerAnimated(true)
            })
        }
    }
    
    //MARK: --UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? parkInfo[0].count : privileges[0].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("defaultCell")
        if cell == nil {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: "defaultCell")
            cell?.backgroundColor = UIColor.clearColor()
            cell?.textLabel?.font = UIFont.systemFontOfSize(XuTextSizeMiddle)
            cell?.detailTextLabel?.font = UIFont.systemFontOfSize(XuTextSizeMiddle)
            if indexPath.section == 1 {cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator}
        }
        let data = (indexPath.section == 0 ? parkInfo : privileges)
        cell?.textLabel?.text = data[0][indexPath.row]
        cell?.detailTextLabel?.text = data[1][indexPath.row]
        return cell!
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
