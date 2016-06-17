//
//  HistoryViewController.swift
//  AutoLife
//
//  Created by 徐成 on 15/11/12.
//  Copyright © 2015年 徐成. All rights reserved.
//

import UIKit

class ParkingRecordViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    var records:NSMutableArray!
    private var tableView:UITableView!
    var cellArraydata:NSMutableArray = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "历史记录"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "message_off"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ParkingRecordViewController.showMessageView(_:)))
        
        //
        self.view.backgroundColor = AlStyle.color.white
        let path = NSBundle.mainBundle().pathForResource("ParkingRecord", ofType: ".plist")
        self.records = NSMutableArray(contentsOfFile: path!)
        for ele in records {
            let dic = NSMutableDictionary(dictionary: ele as! NSDictionary)
            dic.removeObjectForKey("bill")
            self.cellArraydata.addObject(dic)
        }
        
        tableView = UITableView(frame: CGRectMake(0, 0, AlStyle.size.width, AlStyle.size.height + 10),style: UITableViewStyle.Grouped)
        self.view.addSubview(tableView)
        XuSetup(tableView)
        tableView.sectionHeaderHeight = 20
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //MARK: --UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.cellArraydata.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell = self.tableView(self.tableView, cellForRowAtIndexPath: indexPath)
        return cell.frame.height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as? RecordTableViewCell
        if cell == nil {
            cell = RecordTableViewCell(reuseIdentifier: "cell")
        }
        cell?.setupData(cellArraydata[indexPath.section] as! NSDictionary)
        cell?.backgroundColor = UIColor.clearColor()
        cell?.locationClosure = { () in
            print("locationAction")
        }
        cell?.showClosure = { () in
            let sw = self.cellArraydata[indexPath.section]
            self.cellArraydata[indexPath.section] = self.records[indexPath.section]
            self.records[indexPath.section] = sw
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        XutableView(tableView, willDisplayCell: cell, forRowIndexPath: indexPath)
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
