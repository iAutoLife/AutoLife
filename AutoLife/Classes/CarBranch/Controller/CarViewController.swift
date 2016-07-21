//
//  CarViewController.swift
//  AutoLife
//
//  Created by 徐成 on 15/12/14.
//  Copyright © 2015年 徐成. All rights reserved.
//
import UIKit

class CarViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,CarTableViewCellDelegate{
    
    private var tableView:UITableView!
    var carOwnershipArray:NSMutableArray = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initTableView()
    }
    
    func initTableView() {
        self.view.backgroundColor = AlStyle.color.gray_light
        
        self.navigationItem.title = "车辆"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "message_off"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CarViewController.showMessageView(_:)))
        tableView = UITableView(frame: CGRectMake(0, 0, AlStyle.size.width, AlStyle.size.height + 10),style: UITableViewStyle.Grouped)
        self.view.addSubview(tableView)
        XuSetup(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.delaysContentTouches = false
        
        //解析car数据
        let path = NSBundle.mainBundle().pathForResource("CarInfomation", ofType: ".plist")
        for ar in NSArray(contentsOfFile: path!)! {
            let array:NSMutableArray = []
            if let element = ar as? NSArray {
                for value in element {
                    if let dic = value as? NSDictionary {
                        array.addObject(CarOwnership(dic: dic))
                    }
                }
            }
            self.carOwnershipArray.addObject(array)
        }
    }
    
    //MARK: --UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return carOwnershipArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let array = carOwnershipArray[section] as? NSArray else {return 0}
        return array.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell = self.tableView(self.tableView, cellForRowAtIndexPath: indexPath)
        return cell.frame.height
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard section == 1 else {return 0}
        return 40
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: tableView.rectForHeaderInSection(section))
        view.backgroundColor = AlStyle.color.gray_light
        let label = UILabel(frame: CGRectMake(15, 10, 200, 15))
        label.text = (section == 0 ? "车主车辆" : "其他车辆")
        label.font = AlStyle.font.normal
        view.addSubview(label)
        
        return view
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: tableView.rectForFooterInSection(section))
        let button = UIButton(type: UIButtonType.System)
        button.frame = CGRectMake(AlStyle.size.width - 130, 15, 120, 20)
        button.setTitle("添加车辆", forState: UIControlState.Normal)
        button.titleLabel?.font = AlStyle.font.normal
        button.setTitleColor(AlStyle.color.blue_light, forState: UIControlState.Normal)
        button.setImage(UIImage(named: "add"), forState: UIControlState.Normal)
        button.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        button.addTarget(self, action: #selector(CarViewController.addCarlincense(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button)
        
        return view
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("carCell") as? CarTableViewCell
        if cell == nil {
            cell = CarTableViewCell(reuseIdentifier: "carCell")
        }
        cell?.delegate = self
        cell!.backgroundColor = AlStyle.color.gray_light
        let array = carOwnershipArray[indexPath.section] as! NSArray
        if let xco = array[indexPath.row] as? CarOwnership {
            cell?.setupWithCarOwnership(xco)
        }
        cell?.identifyClosure = { () in
            print("identifyAction")
            self.navigationController?.pushViewController(OwnerIdentifyViewController(), animated: true)
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        XutableView(tableView, willDisplayCell: cell, forRowIndexPath: indexPath)
    }
    
    //MARK: --CarTableViewCellDelegate
    func payAuthorizeSwitch(cell: UITableViewCell, bool: Bool) {
        let indexPath = self.tableView.indexPathForCell(cell)
        let array = self.carOwnershipArray[(indexPath?.section)!] as! NSArray
        if let xc = array.objectAtIndex(indexPath!.row) as? CarOwnership {
            xc.isAuthorize = bool
        }
    }
    
    func addCarlincense(sender:UIButton) {
        let newLincenseVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("NewLicensePlateViewController")
        self.presentViewController(UINavigationController(rootViewController: newLincenseVC), animated: true, completion: nil)
//        self.navigationController?.pushViewController(newLincenseVC, animated: true)
    }
    
    //MARK: --ControllerAction
    func showMessageView(sender:UIBarButtonItem) {
//        WeiChatPay.authorizationToLogin(self)
        
//        let messageVC = MessageViewController()
//        self.navigationController?.pushViewController(messageVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
