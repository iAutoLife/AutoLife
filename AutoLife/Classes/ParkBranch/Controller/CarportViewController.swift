//
//  CarportViewController.swift
//  AutoLife
//
//  Created by 徐成 on 15/11/12.
//  Copyright © 2015年 徐成. All rights reserved.
//

import UIKit

class CarportViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,CarportSharesCellDelegate{
    
    private var tableView:UITableView!
    private var carportArray:NSMutableArray = []
    
    override func loadView() {
        self.view = UIView()
        
    }
    
    deinit {
        print("deinit: \(CFGetRetainCount(self))")
    }
    
    override func viewDidDisappear(animated: Bool) {
        print("viewDidDisappear: \(CFGetRetainCount(self))")
    }
    
    override func viewDidAppear(animated: Bool) {
        
        print("viewDidAppear: \(CFGetRetainCount(self))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initTableView()
    }
    
    func initTableView() {
        self.view.backgroundColor = AlStyle.color.gray_light
        
        self.navigationItem.title = "车位"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "message_off"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CarportViewController.showMessageView(_:)))
        
        tableView = UITableView(frame: CGRectMake(0, 0, AlStyle.size.width, AlStyle.size.height + 10),style: UITableViewStyle.Grouped)
        self.view.addSubview(tableView)
        tableView.sectionFooterHeight = 0
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layer.borderWidth = 10
        tableView.layer.cornerRadius = 15
        tableView.layer.borderColor = AlStyle.color.gray_light.CGColor
        tableView.backgroundColor = AlStyle.color.gray_light
        tableView.separatorColor = AlStyle.color.gray_light
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let path = NSBundle.mainBundle().pathForResource("Carport", ofType: ".plist")
        for ele in NSArray(contentsOfFile: path!)! {
            self.carportArray.addObject(Carport(dict: ele as! NSDictionary))
        }
    }
    
    //MARK: --UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.carportArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: tableView.rectForHeaderInSection(section))
        view.backgroundColor = AlStyle.color.gray_light
        let label = UILabel(frame: CGRectMake(15, 10, 200, 15))
        label.text = "车位\(section + 1)"
        label.font = AlStyle.font.normal
        view.addSubview(label)
        
        return view
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == self.carportArray.count - 1 {
            return 50
        }
        return 0
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == self.carportArray.count - 1 else {return nil}
        let view = UIView(frame: tableView.rectForFooterInSection(section))
        view.backgroundColor = AlStyle.color.gray_light
        let ruleButton = UIButton(type: UIButtonType.System);let str:NSString = "《车位分享规则》"
        ruleButton.setTitle(str as String, forState: UIControlState.Normal)
        ruleButton.titleLabel?.font = AlStyle.font.normal
        ruleButton.setTitleColor(AlStyle.color.blue_light, forState: UIControlState.Normal)
        ruleButton.addTarget(self, action: #selector(CarportViewController.showAcProtocol(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(ruleButton)
        ruleButton.frame = CGRectMake(5, 10, AlStyle.font.normal.pointSize * CGFloat(str.length), 20)
        
        let button = UIButton(type: UIButtonType.System)
        button.frame = CGRectMake(AlStyle.size.width - 70, 10, 60, 20)
        button.setTitle("添加车位", forState: UIControlState.Normal)
        button.titleLabel?.font = AlStyle.font.normal
        button.setTitleColor(AlStyle.color.blue_light, forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(CarportViewController.addCarlincense(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button)
        
        let addBtn = UIButton(type: UIButtonType.System)
        addBtn.frame = CGRectMake(CGRectGetMinX(button.frame) - 25, 13, 25, 15)
        addBtn.setImage(UIImage(named: "add"), forState: UIControlState.Normal)
        addBtn.addTarget(self, action: #selector(CarportViewController.addCarlincense(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(addBtn)
        
        return view
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 2 {
            guard let carport = self.carportArray[indexPath.section] as? Carport else {return 0}
            return (CGFloat(carport.shares!.count) + 1) * AlStyle.cellHeight
        }
        return AlStyle.cellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let carport = self.carportArray[indexPath.section] as? Carport else {return UITableViewCell()}
        
        switch indexPath.row {
        case 0:
            var cell = tableView.dequeueReusableCellWithIdentifier("cell0") as? UniversalTableViewCell
            if cell == nil {
                cell = UniversalTableViewCell(universalStyle: UniversalCellStyle.RightButton, reuseIdentifier: "cell0")
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            let title:NSMutableString = NSMutableString(string: carport.title!)
            if carport.isrent {
                title.appendString("（租赁\(carport.payway!)）")
                cell?.rightButtonTitle = "续费"
                cell?.rightButtonClicked = { [unowned self]() in
                    print("续费")
                    let rentVC = TBViewController()
                    self.navigationController?.pushViewController(rentVC, animated: true)
                }
            }
            cell?.leftLabelText = title as String
            cell?.backgroundColor = AlStyle.color.gray_light
            return cell!
        case 1:
            var cell = tableView.dequeueReusableCellWithIdentifier("cell1") as? UniversalTableViewCell
            if cell == nil {
                cell = UniversalTableViewCell(universalStyle: UniversalCellStyle.RightLabel, reuseIdentifier: "cell1")
            }
            cell?.leftLabelText = "车位收益"
            cell?.rightLabelText = carport.revenue
            cell?.backgroundColor = AlStyle.color.gray_light
            return cell!
        case 2:
            var cell = tableView.dequeueReusableCellWithIdentifier("cell2") as? CarportTableViewCell
            if cell == nil {
                cell = CarportTableViewCell(reuseIdentifier: "cell2")
                cell?.delegate = self
            }
            cell?.shares = carport.shares!
            cell?.backgroundColor = AlStyle.color.gray_light
            return cell!
        default:return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("didSelectRowAtIndexPath: \(CFGetRetainCount(self))")
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        XutableView(tableView, willDisplayCell: cell, forRowIndexPath: indexPath)
    }
    
    //MARK:--CarportSharesCellDelegate
    func CarportAddButtonClicked(cell: UITableViewCell) {
        let indexPath = tableView.indexPathForCell(cell)
        print(indexPath)
    }
    
    func CarportSwitchChanged(cell: UITableViewCell, boolValue: Bool,index:Int) {
        let indexPath = tableView.indexPathForCell(cell)
        print("switch>>>>>>>>index:\(index)")
        print(indexPath?.section)
        print(boolValue)
        
    }
    
    //MARK: --ControllerAction
    func showMessageView(sender:UIBarButtonItem) {
        let messageVC = MessageViewController()
        self.navigationController?.pushViewController(messageVC, animated: true)
        
    }
    
    func showAcProtocol(sender:UIButton) {
        self.navigationController?.pushViewController(AgreementViewController(), animated: true)
    }
    
    func addCarlincense(sender:UIButton) {
//        let newLincenseVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("NewLicensePlateViewController")
//        self.navigationController?.pushViewController(newLincenseVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
