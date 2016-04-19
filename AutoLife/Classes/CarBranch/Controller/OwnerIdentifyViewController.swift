//
//  OwnerIdentifyViewController.swift
//  AutoLife
//
//  Created by 徐成 on 15/12/14.
//  Copyright © 2015年 徐成. All rights reserved.
//
import UIKit

class OwnerIdentifyViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    private var tableView:UITableView!
    
    let array = ["车牌号码","车辆类型","使用性质","注册日期","发证日期","发动机号码","品牌型号","车辆识别代号","所有人","住址"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = XuColorWhite
        self.navigationItem.title = "车主认证"
        tableView = UITableView(frame: CGRectMake(0, 0, XuWidth, XuHeight + 10),style: UITableViewStyle.Grouped)
        self.view.addSubview(tableView)
        XuSetup(tableView)
        tableView.sectionHeaderHeight = 20
        tableView.dataSource = self
        tableView.delegate = self
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: tableView.rectForFooterInSection(section))
        let button = UIButton(type: UIButtonType.System)
        button.frame = CGRectMake(10, CGRectGetHeight(tableView.rectForFooterInSection(section)) - 40, XuWidth - 20, 30)
        button.setTitle("确 定", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.backgroundColor = XuColorBlue
        button.layer.cornerRadius = XuCornerRadius
        button.addTarget(self, action: #selector(OwnerIdentifyViewController.submitEnsureAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button)
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell = self.tableView(self.tableView, cellForRowAtIndexPath: indexPath)
        return cell.frame.height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as? UniversalTableViewCell
        if cell == nil {
            cell = UniversalTableViewCell(universalStyle: UniversalCellStyle.TextField, reuseIdentifier: "cell")
            cell?.backgroundColor = UIColor.clearColor()
        }
        cell?.textPlaceholder = array[indexPath.row]
        if indexPath.row == 4 || indexPath.row == 3 {
            cell?.textInputType = XuTextFieldInputType.Date
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        XutableView(tableView, willDisplayCell: cell, forRowIndexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? UniversalTableViewCell {
            guard cell.textField != nil else {return}
            if !cell.textField!.isFirstResponder() {
                cell.textField?.becomeFirstResponder()
            }
        }
    }
    
    func submitEnsureAction(sender:UIButton) {
        print("submitEnsureAction")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
