//
//  PickerViewController.swift
//  AutoLife
//
//  Created by xubupt218 on 16/1/22.
//  Copyright © 2016年 徐成. All rights reserved.
//

import UIKit

protocol BrandPickerDelegate {
    func brandPickerDidCancel()
    func brandPickerDidGoback()
    func brandPickerDidFinish(id:String,brand:String,hasNext: Bool)
}

class PickerViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    private var tableView:UITableView!
    
    var brandJSON:JSON = JSON.null {
        didSet{
            guard self.tableView != nil else {return}
            self.tableView.reloadData()
            if self.brandJSON[0].count == 3 {
                isEnd = true
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "上一级", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PickerViewController.didGoback(_:)))
            }else {
                isEnd = false
            }
        }
    }
    var delegate:BrandPickerDelegate?
    var backgroundView:UIView?
    var isEnd = false

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView = UIView(frame: UIScreen.mainScreen().bounds)
        backgroundView?.backgroundColor = UIColor.blackColor();backgroundView?.alpha = 0.0
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "didCancel:")
        
        tableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.width - 45, XuHeight + 10),style: UITableViewStyle.Grouped)
        self.view.addSubview(tableView)
        XuSetup(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 36
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    func didCancel(sender:UIBarButtonItem) {
        self.delegate?.brandPickerDidCancel()
    }
    
    func didGoback(sender:UIBarButtonItem) {
        self.delegate?.brandPickerDidGoback()
    }

    
    //MARK:--UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        print(brandJSON.count)
        return brandJSON.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
            cell?.backgroundColor = UIColor.clearColor()
            cell?.textLabel?.font = UIFont.systemFontOfSize(XuTextSizeMiddle)
        }
        var text = "不确定"
        if indexPath.section == 1 {
            switch brandJSON[indexPath.row].count {
            case 2:text = brandJSON[indexPath.row]["model_name"].string!
            case 3:
                text = brandJSON[indexPath.row]["type_series"].string! + " " +
                    brandJSON[indexPath.row]["type_name"].string!
            default:print("other data")
            }
        }
        cell?.textLabel?.text = text
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(brandJSON[indexPath.row]["id"])
        if indexPath.section == 0 {
            delegate?.brandPickerDidFinish("", brand: "", hasNext: false)
            return
        }
        if !isEnd {
            let brand = self.brandJSON[indexPath.row]["model_name"].string!
            let id = "\(self.brandJSON[indexPath.row]["id"])"
            delegate?.brandPickerDidFinish(id, brand: brand, hasNext: true)
        }else {
            let brand = brandJSON[indexPath.row]["type_series"].string! + " " + brandJSON[indexPath.row]["type_name"].string!
            let id =  "\(self.brandJSON[indexPath.row]["id"].int!)"
            delegate?.brandPickerDidFinish(id, brand: brand, hasNext: false)
            
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        XutableView(tableView, willDisplayCell: cell, forRowIndexPath: indexPath)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
