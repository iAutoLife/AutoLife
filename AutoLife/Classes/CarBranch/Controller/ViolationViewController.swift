//
//  ViolationViewController.swift
//  AutoLife
//
//  Created by xubupt218 on 15/12/17.
//  Copyright © 2015年 徐成. All rights reserved.
//

import UIKit

class ViolationViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,VArrayTableViewCellDelegate{
    
    private var tableView:UITableView!
    var violationArray:NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initTableView()
    }
    
    func initTableView() {
        self.view.backgroundColor = XuColorGrayThin
        
        self.navigationItem.title = "违章"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "message_off"), style: UIBarButtonItemStyle.Plain, target: self, action: "showMessageView:")
        
        tableView = UITableView(frame: CGRectMake(0, 0, XuWidth, XuHeight + 10),style: UITableViewStyle.Grouped)
        self.view.addSubview(tableView)
        XuSetup(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let path = NSBundle.mainBundle().pathForResource("Violations", ofType: ".plist")
        for elem in NSArray(contentsOfFile: path!)! {
            if let dic = elem as? NSDictionary {
                self.violationArray.addObject(ViolationObject(dic: dic))
            }
        }
    }
    
    //MARK: --UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.violationArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let violation = violationArray[section] as? ViolationObject {
            guard violation.info != nil else {return 2}
            return 3
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 2 {
            if let violation = violationArray[indexPath.section] as? ViolationObject {
                guard violation.info != nil else {return 0}
                return 50 * CGFloat(violation.info!.count)
            }
        }
        return 50
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let vio = self.violationArray[indexPath.section] as? ViolationObject else {return UITableViewCell()}
        switch indexPath.row {
        case 0,1:
            var cell = tableView.dequeueReusableCellWithIdentifier("rbCell") as? UniversalTableViewCell
            if cell == nil {
                cell = UniversalTableViewCell(universalStyle: UniversalCellStyle.RightButton, reuseIdentifier: "rbCell")
                cell?.backgroundColor = UIColor.clearColor()
            }
            if indexPath.row == 1{
                cell?.leftLabelText = "未处理 \(vio.times!) 扣分 \(vio.points!) 罚款 \(vio.forfeit!)"
            }else {
                cell?.leftLabelText = vio.plate
                if vio.info != nil {
                    cell?.rightButtonTitle = "违章处理"
                }
            }
            return cell!
        case 2:
            var cell = tableView.dequeueReusableCellWithIdentifier("detaledCell") as? VArrayTableViewCell
            if cell == nil {
                cell = VArrayTableViewCell(reuseIdentifier: "detailedCell")
                cell?.backgroundColor = UIColor.clearColor()
                cell?.delegate = self
            }
            cell?.dataArray = vio.info
            return cell!
        default:return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        XutableView(tableView, willDisplayCell: cell, forRowIndexPath: indexPath)
    }
    
    //MARK: --ArrayTableViewCellDelegate
    func arrayTableViewCellLocation(row: Int,superCell:UITableViewCell) {
        
    }
    
    func arrayTableViewCellSelected(row: Int,superCell:UITableViewCell) {
        guard let vio = self.violationArray[tableView.indexPathForCell(superCell)!.section] as? ViolationObject else {return}
        guard vio.info != nil else {return}
        let violationDetailVC = ViolationDetailViewController()
        violationDetailVC.xviolation = vio.info![row] as? NSDictionary
        violationDetailVC.navigationItem.title = vio.plate
        self.navigationController?.pushViewController(violationDetailVC, animated: true)
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

