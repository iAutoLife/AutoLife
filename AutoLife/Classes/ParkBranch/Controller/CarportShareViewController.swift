//
//  CarportShareViewController.swift
//  AutoLife
//
//  Created by 徐成 on 15/11/12.
//  Copyright © 2015年 徐成. All rights reserved.
//
import UIKit

class CarportShareViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    
    private var tableView:UITableView!
    lazy private var currentIndex = 0
    private var currentState:NSArray!
    private var statesDic:NSDictionary = [:]
    let chTexts = [["停入车辆时间","当前时长","预计收益"],["分享车位名称","分享时间段","分享收益"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "message_off"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CarportShareViewController.showMessageView(_:)))
        self.getStateData()
        
        tableView = UITableView(frame: CGRectMake(0, 0, XuWidth, XuHeight + 10),style: UITableViewStyle.Grouped)
        self.view.addSubview(tableView)
        XuSetup(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func getStateData() {
        let path = NSBundle.mainBundle().pathForResource("CarportState", ofType: ".plist")
        self.statesDic = NSDictionary(contentsOfFile: path!)!
        let titleView = NavTitleView(count: statesDic.count)
        titleView.title = statesDic.allKeys[0] as? String
        self.navigationItem.titleView = titleView
        self.currentState = self.statesDic.objectForKey(statesDic.allKeys.first!) as? NSArray
        titleView.changedAction = { (type) in
            if type == XuTitleViewChangeType.Left {
                if --self.currentIndex < 0 {self.currentIndex = 0}
                let key = self.statesDic.allKeys[self.currentIndex]
                self.currentState = self.statesDic.objectForKey(key) as? NSArray
                titleView.title = key as? String
                self.tableView.reloadData()
            }else {
                if ++self.currentIndex > self.statesDic.count - 1 {self.currentIndex = self.statesDic.count - 1}
                let key = self.statesDic.allKeys[self.currentIndex]
                self.currentState = self.statesDic.objectForKey(key) as? NSArray
                titleView.title = key as? String
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: --UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.currentState.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let array = self.currentState[section] as? NSArray else {return 0}
        return array.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let xar = self.currentState[indexPath.section] as? NSArray else {return UITableViewCell() }
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as? UniversalTableViewCell
        if cell == nil {
            cell = UniversalTableViewCell(universalStyle: UniversalCellStyle.RightLabel, reuseIdentifier: "cell")
            cell?.backgroundColor = UIColor.clearColor()
        }
        cell?.leftLabelText = chTexts[indexPath.section][indexPath.row]
        cell?.rightLabelText = xar[indexPath.row] as? String
        if indexPath.section == 0 {
            cell?.leftShift = 120
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let leftShift:CGFloat = (indexPath.section == 0 ? 120 : 0)
        XutableView(tableView, willDisplayCell: cell, forRowIndexPath: indexPath, leftShft: leftShift)
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
