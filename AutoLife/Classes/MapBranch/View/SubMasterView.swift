//
//  SubMasterView.swift
//  AutoLife
//
//  Created by 徐成 on 15/11/2.
//  Copyright © 2015年 徐成. All rights reserved.
//

import UIKit

protocol SubMasterViewDelegate {
    func SubMasterClicked(index:Int)
}

class SubMasterView: UIView ,UITableViewDataSource,UITableViewDelegate{
    
    var tableView:UITableView!
    let section0 = [["支付":"绑定 京A B1212 在线支付 开"],["历史记录":""]]
    let section1 = [["车辆":"京A B1212 车主未认证"],["车位":"车位分享 开"],["违章":"未处理 1"],["保险":""]]
    let section2 = [["优惠":"3张"],["推荐有奖":"停车享优惠"]]
    let section3 = [["设置":""]]
    let imageNames = [["pay","record"],["car","carport","violation","insurance"],["coupon","recommend"],["setting"]]
    var tableArray : NSMutableArray = []//section0,section1,section2,section3]
    var delegate:SubMasterViewDelegate?
    
    init() {
        super.init(frame: UIScreen.mainScreen().bounds)//CGRectMake(0, 0, XuWidth * 2 / 3, UIScreen.mainScreen().bounds.size.height))
        self.backgroundColor = UIColor(red: 24/255, green: 30/255, blue: 36/255, alpha: 1)
        self.alpha = 0.96
        self.tableArray.addObject(section0)
        self.tableArray.addObject(section1)
        self.tableArray.addObject(section2)
        self.tableArray.addObject(section3)
        self.initTableView()
    }
    
    func initTableView() {
        tableView = UITableView(frame: CGRectMake(XuWidth / 3, 0, XuWidth * 2 / 3, XuHeight), style: UITableViewStyle.Plain)
        tableView.backgroundColor = UIColor(red: 24/255, green: 30/255, blue: 36/255, alpha: 1)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.scrollEnabled = false
        self.addSubview(tableView)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 64
        }
        return 0.5
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let line = UIView(frame: CGRectMake(14.5, 0, XuWidth * 2 / 3 - 15, 0.5))
        line.backgroundColor = UIColor(red: 0, green: 89/255, blue: 131/255, alpha: 1)
        if section > 0 {
            let view = UIView(frame: CGRectMake(0, 0, XuWidth, 0.5))
            view.addSubview(line)
            return view
        }
        let view = UIView(frame: tableView.rectForHeaderInSection(section))
        let imageView = UIImageView(frame: CGRectMake(14, 18.5, 40, 40))
        imageView.image = UIImage(named: "logo")
        view.addSubview(imageView)
        let label = UILabel(frame: CGRectMake(70, 18, 180, 20))
        label.text = "爱车人 | 车主"
        label.font = UIFont.systemFontOfSize(XutextSizeBig)
        view.addSubview(label)
        label.textColor = UIColor.whiteColor()
        
        let label1 = UILabel(frame: CGRectMake(70, 39, 180, 20))
        label1.text = "187****1234"
        label1.textColor = UIColor.whiteColor()
        label1.font = UIFont.systemFontOfSize(XutextSizeBig)
        view.addSubview(label1)
        view.backgroundColor = UIColor.clearColor()
        line.center.y = view.frame.height - 0.5
        view.addSubview(line)
        let tap = UITapGestureRecognizer(target: self, action: "headerViewTap:")
        view.addGestureRecognizer(tap)
        return view
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dic = self.tableArray[section] as! NSArray
        return dic.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "subMasterCell")
        }
        cell?.imageView?.image = UIImage(named: imageNames[indexPath.section][indexPath.row])
        let dic = (self.tableArray[indexPath.section] as! NSArray)[indexPath.row] as! NSDictionary
        let keys:NSArray = dic.allKeys
        cell?.textLabel?.text = keys[0] as? String
        cell?.textLabel?.textColor = UIColor.whiteColor()
        cell?.textLabel?.font = UIFont.systemFontOfSize(XuTextSizeMiddle)
        cell?.detailTextLabel?.text = dic.objectForKey(String(keys[0])) as? String
        cell?.detailTextLabel?.font = UIFont.systemFontOfSize(XuTextSizeSmallest)
        cell?.backgroundColor = UIColor.clearColor()
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        var index = 0
        switch indexPath.section {
        case 0:
            index = 1 + indexPath.row
        case 1:
            index = 1 + section0.count + indexPath.row
        case 2:
            index = 1 + section0.count + section1.count + indexPath.row
        case 3:
            index = 1 + section0.count + section1.count + section2.count + indexPath.row
        default:break
        }
        self.postNotification()
        delegate?.SubMasterClicked(index)
    }
    
    func headerViewTap(recoginzer:UITapGestureRecognizer) {
        self.postNotification()
        delegate?.SubMasterClicked(0)
    }
    
    func postNotification() {
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationOfHideSubMaster, object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
