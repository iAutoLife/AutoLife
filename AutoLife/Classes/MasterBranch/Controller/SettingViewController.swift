//
//  SettingViewController.swift
//  AutoLife
//
//  Created by 徐成 on 16/1/14.
//  Copyright © 2016年 徐成. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    private var tableView:UITableView!
    
    let tbArray = [["修改密码","清理缓存"],["交易消息提醒","活动推送提醒"],
        ["帮助","意见反馈","好评打赏","法律条款","关于我们"],["退 出 登 录"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = AlStyle.color.white
        self.navigationItem.title = "设置"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "message_off"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SettingViewController.showMessageView(_:)))
        
        tableView = UITableView(frame: CGRectMake(0, 0, AlStyle.size.width, AlStyle.size.height + 10),style: UITableViewStyle.Grouped)
        self.view.addSubview(tableView)
        XuSetup(tableView)
        tableView.sectionHeaderHeight = 20
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //MARK: --UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.tbArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let array = tbArray[section] as NSArray
        return array.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == self.tbArray.count - 1 {
            return 30
        }
        return AlStyle.cellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0,2:
            var cell = tableView.dequeueReusableCellWithIdentifier("tCell") as? UniversalTableViewCell
            if cell == nil {
                cell = UniversalTableViewCell(universalStyle: UniversalCellStyle.RightLabel, reuseIdentifier: "tCell")
                cell?.backgroundColor = UIColor.clearColor()
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            cell?.leftLabelText = tbArray[indexPath.section][indexPath.row]
            return cell!
        case 1:
            var cell = tableView.dequeueReusableCellWithIdentifier("sCell") as? UniversalTableViewCell
            if cell == nil {
                cell = UniversalTableViewCell(universalStyle: UniversalCellStyle.RightSwitch, reuseIdentifier: "sCell")
                cell?.backgroundColor = UIColor.clearColor()
            }
            cell?.leftLabelText = tbArray[indexPath.section][indexPath.row]
            cell?.rSwitchState = false
            return cell!
        case 3:
            let cell = UITableViewCell(frame: CGRectMake(0, 0, AlStyle.size.width, 30))
            let label = UILabel(frame: CGRectMake(0, 0, AlStyle.size.width, 30))
            let text = tbArray[indexPath.section][indexPath.row]
            label.text = text as String
            label.textAlignment = NSTextAlignment.Center
            label.font = AlStyle.font.normal
            cell.contentView.addSubview(label)
            cell.backgroundColor = UIColor.clearColor()
            return cell
        default:return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        XutableView(tableView, willDisplayCell: cell, forRowIndexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        if indexPath.section == 3 {
            let url = AlStyle.uHeader + "applogin/cleanToken?phone=" + XuKeyChain.get(XuCurrentUser)!
            XuAlamofire.getString(url, success: { (result) in
                print(result)
                if result == "true" {
                    XuKeyChain.remove(XuCurrentUser)
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                }, failed: nil)
        }
    }
    
    //MARK: --ControllerAction
    func showMessageView(sender:UIBarButtonItem) {
        let messageVC = MessageViewController()
        self.navigationController?.pushViewController(messageVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
