//
//  ReceiptViewController.swift
//  ShareAndNav
//
//  Created by xubupt218 on 15/11/13.
//  Copyright © 2015年 徐成. All rights reserved.
//

import UIKit

class ReceiptViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,XuPickerViewDelegate,UITextFieldDelegate{
    
    private var tableView:UITableView!
    
    let tbArray = [["收件人","收件人电话","省、市、区","详细地址"],["开票金额","发票抬头","发票内容"]]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initTableView()
    }
    
    func initTableView() {
        self.view.backgroundColor = XuColorGrayThin
        
        self.navigationItem.title = "开具发票"
        
        tableView = UITableView(frame: CGRectMake(0, 0, XuWidth, XuHeight + 10),style: UITableViewStyle.Grouped)
        self.view.addSubview(tableView)
        XuSetup(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //MARK: --UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tbArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tbArray[section].count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 60
        }
        return 0
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: tableView.rectForFooterInSection(section))
        
        let label = UILabel(frame: CGRectMake(12,5,XuWidth - 10,XuTextSizeMiddle))
        label.text = "200元以下支付¥5.00元邮费，200以上（含）免邮费"
        label.font = UIFont.systemFontOfSize(XuTextSizeSmallest)
        label.textColor = XuColorGray
        view.addSubview(label)
        
        let button = UIButton(type: UIButtonType.System)
        button.frame = CGRectMake(10, 30, XuWidth - 20, 30)
        button.setTitle("确 定", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.backgroundColor = XuColorBlue
        button.layer.cornerRadius = XuCornerRadius
        view.addSubview(button)
        button.handleControlEvent(UIControlEvents.TouchUpInside) { (_) -> Void in
            print("确定")
        }
        return view
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as? UniversalTableViewCell
        if cell == nil {
            cell = UniversalTableViewCell(universalStyle: UniversalCellStyle.TextField, reuseIdentifier: "cell")
        }
        cell?.leftLabelText = tbArray[indexPath.section][indexPath.row]
        cell?.textPlaceholder = "\(tbArray[indexPath.section][indexPath.row])"
        cell?.backgroundColor = UIColor.clearColor()
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        if cell?.leftLabelText == "省、市、区" {
            let pickerView = XuPickerView(style: XuPickerStyle.CityAndArea)
            pickerView.delegate = self
            cell?.textInputType = XuTextFieldInputType.CityAndArea
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        XutableView(tableView, willDisplayCell: cell, forRowIndexPath: indexPath)
    }
    
    //MARK: --XuPickerViewDelegate
    func XuPickerViewDidCancel() {
        UITextField.appearance().resignFirstResponder()
    }
    
    func XuPickerViewDidSelected(pickerString: String) {
        UITextField.appearance().resignFirstResponder()
        print(pickerString)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
