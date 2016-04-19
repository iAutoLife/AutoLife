//
//  ViolationDetailViewController.swift
//  AutoLife
//
//  Created by 徐成 on 15/12/14.
//  Copyright © 2015年 徐成. All rights reserved.
//


import UIKit

class ViolationDetailViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    private var tableView:UITableView!
    var xviolation:NSDictionary?
    
    private let chMessages = [["date":"违章时间"],["address":"违章地点"],["reason":"违章原因"],["point":"扣分情况"],["forfeit":"罚款金额"],["numbers":"违章人数"],["content":"违章内容"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initTableView()
    }
    
    func initTableView() {
        self.view.backgroundColor = XuColorGrayThin
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "message_off"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("showMessageView:"))
        
        tableView = UITableView(frame: CGRectMake(0, 0, XuWidth, XuHeight + 10),style: UITableViewStyle.Grouped)
        self.view.addSubview(tableView)
        XuSetup(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //MARK: --UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chMessages.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch chMessages[indexPath.row].keys.first! {
        case "address":
            guard XuWidth < 375 else {return 50}
            let content = xviolation?["address"] as? String
            return (content?.sizeWithMaxSize(CGSizeMake(200, 200), fontSize: XuTextSizeMiddle).height)! + 36
        case "content":
            let content = xviolation?["content"] as? String
            return (content?.sizeWithMaxSize(CGSizeMake(XuWidth - 120, XuWidth - 120), fontSize: XuTextSizeMiddle).height)! + 36
        default:return 50
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as? UniversalTableViewCell
        if cell == nil {
            cell = UniversalTableViewCell(universalStyle: UniversalCellStyle.RightLabel, reuseIdentifier: "cell")
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
            cell?.backgroundColor = UIColor.clearColor()
        }
        let dic = chMessages[indexPath.row]
        cell?.rightLabelText = xviolation?.objectForKey(dic.keys.first!) as? String
        cell?.leftLabelText = dic.values.first
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        XutableView(tableView, willDisplayCell: cell, forRowIndexPath: indexPath)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
