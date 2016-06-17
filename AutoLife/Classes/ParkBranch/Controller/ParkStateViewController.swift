//
//  ParkStateViewController.swift
//  AutoLife
//
//  Created by 徐成 on 15/11/12.
//  Copyright © 2015年 徐成. All rights reserved.
//

import UIKit

class ParkStateViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource {
    //,XuCameraDelegate
    private var tableView:UITableView!
    lazy private var currentIndex = 0
    private var currentState:NSArray!
    private var statesDic:NSDictionary = [:]
    private var chTexts = [["驶入时间","当前费用"],["停车场","停车位","收费标准"],["在线支付状态","可用优惠券"]]
    private var carportImageView:UIImageView?
    private var carportImage:UIImage? {
        didSet{
            guard carportImageView != nil else {return}
            carportImageView?.image = carportImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "message_off"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ParkStateViewController.showMessageView(_:)))
        self.getStateData()
        
        tableView = UITableView(frame: CGRectMake(0, 0, AlStyle.size.width, AlStyle.size.height + 10),style: UITableViewStyle.Grouped)
        self.view.addSubview(tableView)
        XuSetup(tableView)
        tableView.sectionHeaderHeight = 20
        tableView.dataSource = self
        tableView.delegate = self
        self.timingView()
    }
    
    func getStateData() {
        let path = NSBundle.mainBundle().pathForResource("ParkState", ofType: ".plist")
        self.statesDic = NSDictionary(contentsOfFile: path!)!
        let titleView = NavTitleView(count: statesDic.count)
        titleView.title = statesDic.allKeys[0] as? String
        self.navigationItem.titleView = titleView
        self.currentState = self.statesDic.objectForKey(statesDic.allKeys.first!) as? NSArray
        titleView.changedAction = { (type) in
            if type == XuTitleViewChangeType.Left {
                self.currentIndex -= 1
                if self.currentIndex < 0 {self.currentIndex = 0}
                let key = self.statesDic.allKeys[self.currentIndex]
                self.currentState = self.statesDic.objectForKey(key) as? NSArray
                titleView.title = key as? String
                self.tableView.reloadData()
            }else {
                self.currentIndex += 1
                if self.currentIndex > self.statesDic.count - 1 {self.currentIndex = self.statesDic.count - 1}
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        guard let array = self.currentState[indexPath.section] as? NSArray else {return XuCellHeight}
        if let ar = array[indexPath.row] as? NSArray {
            return XuCellHeight * CGFloat(ar.count)
        }
        return XuCellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let object = (self.currentState[indexPath.section] as! NSArray)[indexPath.row]
        switch object {
        case is String:
            return self.cellWithString(indexPath, object: object)
        case is Bool:
            var cell = tableView.dequeueReusableCellWithIdentifier("cell1") as? UniversalTableViewCell
            if cell == nil {
                cell = UniversalTableViewCell(universalStyle: UniversalCellStyle.RightSwitch, reuseIdentifier: "cell1")
                cell?.backgroundColor = UIColor.clearColor()
                cell?.selectionStyle = UITableViewCellSelectionStyle.None
            }
            cell?.leftLabelText = self.chTexts[indexPath.section][indexPath.row]
            cell?.rSwitchState = (object as? Bool)!
            if indexPath.section == 0 {cell?.leftShift = 120}
            cell?.rightSwitchChanged = { (boolValue) in
                print(boolValue)
            }
            return cell!
        case is NSArray:
            var cell = tableView.dequeueReusableCellWithIdentifier("cell2") as? ArrayTBCell
            if cell == nil {
                cell = ArrayTBCell(reuseIdentifier: "cell2")
                cell?.backgroundColor = UIColor.clearColor()
                cell?.selectionStyle = UITableViewCellSelectionStyle.None
            }
            cell?.title = self.chTexts[indexPath.section][indexPath.row]
            cell?.xarray = object as! NSArray
            return cell!
            
        default:return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == self.currentState.count - 1 {
            return 150
        }
        return 0
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRectMake(0,0,AlStyle.size.width,150))
        let alertButton = UIButton(type: UIButtonType.System)
        alertButton.setup("警 报", fontsize: AlStyle.font.normal.pointSize, fontColor: UIColor.whiteColor(), bkColor: AlStyle.color.blue)
        alertButton.center = CGPointMake(40, 30);view.addSubview(alertButton)
        alertButton.handleControlEvent(UIControlEvents.TouchUpInside) { (_) -> Void in
//            let camera = XuCamera()
//            camera.delegate = self
//            camera.openPictureLibrary(self)
            
            let alert = UIAlertController(title: "这是一个警报", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        carportImageView = UIImageView(frame: CGRectMake(CGRectGetMaxX(alertButton.frame) + 10, CGRectGetMinY(alertButton.frame), 100, 80))
        view.addSubview(carportImageView!)
        return view
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        XutableView(tableView, willDisplayCell: cell, forRowIndexPath: indexPath)
    }
    
    //MARK: --XuCameraDelegate
    func XuCameraDidPickImage(image: UIImage) {
        print(image.size)
        self.carportImage = image
    }
    
    func XuCameraDidCancel() {
        print("cancel")
    }
    
    //MARK: --ControllerAction
    func showMessageView(sender:UIBarButtonItem) {
        let messageVC = MessageViewController()
        self.navigationController?.pushViewController(messageVC, animated: true)
    }
    
    func timingView(){
        let view = UIImageView(frame: CGRectMake(10, 35, 120, 70))
        view.image = UIImage(named: "timing")
        view.layer.cornerRadius = AlStyle.cornerRadius
        self.tableView.addSubview(view)
        if (UIDevice.currentDevice().systemVersion as AnyObject).floatValue >= 8.0 {
            self.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        }
    }
    
    func cellWithString(indexPath:NSIndexPath,object:AnyObject) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as? UniversalTableViewCell
        if cell == nil {
            cell = UniversalTableViewCell(universalStyle: UniversalCellStyle.RightLabel, reuseIdentifier: "cell")
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
            cell?.backgroundColor = UIColor.clearColor()
        }
        cell?.leftLabelText = self.chTexts[indexPath.section][indexPath.row]
        cell?.rightLabelText = object as? String
        if indexPath.section == 0 {cell?.leftShift = 120}
        if indexPath == NSIndexPath(forRow: 1, inSection: 1) {
            cell?.initRightButton()
            cell?.rightButtonTitle = "车位拍照"
            cell?.rightButtonClicked = { () in
                print("click cheweipaizhao")
//                let camera = XuCamera()
//                camera.delegate = self
//                camera.takePhoto(self)
            }
            
        }
        return cell!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class ArrayTBCell: UITableViewCell ,UITableViewDataSource,UITableViewDelegate{
    private var tableView:UITableView!
    private var xarray:NSArray! {
        didSet{
            tableView.frame = CGRectMake(0,0,AlStyle.size.width,CGFloat(xarray.count) * XuCellHeight)
            tableView.reloadData()
        }
    }
    private var title:String = ""
    
    init(reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        tableView = UITableView(frame: CGRectZero);
        tableView.scrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = XuCellHeight
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorColor = AlStyle.color.gray_light
        self.addSubview(tableView)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return xarray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as? UniversalTableViewCell
        if cell == nil {
            cell = UniversalTableViewCell(universalStyle: UniversalCellStyle.RightLabel, reuseIdentifier: "cell")
            cell?.backgroundColor = UIColor.clearColor()
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
        }
        if indexPath.row == 0 {cell?.leftLabelText = self.title}
        cell?.rightLabelText = self.xarray[indexPath.row] as? String
        cell?.separatorInset = UIEdgeInsetsMake(0, 75, 0, 0)
        return cell!
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum XuTitleViewChangeType {
    case Left,Right
}

class NavTitleView: UIView {
    
    private var currentIndex:Int = 0
    private var label:UILabel!
    private var left:UIButton!
    private var right:UIButton!
    private var count:Int = 0
    private var eventChanged = "eventChanged"
    var title:String? {
        didSet{
            self.label.text = title
        }
    }
    
    var changedAction : ((XuTitleViewChangeType) -> Void)?
    
    init(count: Int) {
        super.init(frame: CGRectMake(0, 0, 120, 44))
        self.initView(count)
    }
    
    func initView(count:Int) {
        label = UILabel(frame: CGRectMake(0,20,90,30))
        label.font = UIFont.systemFontOfSize(17, weight: 0.3)
        label.textAlignment = NSTextAlignment.Center
        label.center = CGPointMake(self.frame.width / 2, 22)
        self.addSubview(label)
        self.count = count
        if count > 1 {
            self.initRightButton()
        }
    }
    
    func initLeftButton() {
        left = UIButton(type: UIButtonType.System)
        left.setImage(UIImage(named: "left"), forState: UIControlState.Normal)
        left.frame = CGRectMake(0, 0, 40, 40)
        left.center = CGPointMake(self.frame.width / 2 - 60, 22)
        self.addSubview(left)
        left.handleControlEvent(UIControlEvents.TouchUpInside) { (_) -> Void in
            print("left")
            self.currentIndex -= 1
            if self.currentIndex == 0 {
                self.left.hidden = true
            }
            if self.currentIndex != self.count - 1 {
                self.right.hidden = false
            }
            self.changedAction?(XuTitleViewChangeType.Left)
        }
    }
    
    func initRightButton() {
        right = UIButton(type: UIButtonType.System)
        right.setImage(UIImage(named: "right"), forState: UIControlState.Normal)
        right.frame = CGRectMake(CGRectGetMaxX(self.label.frame) + 10, 0, 40, 40)
        right.center = CGPointMake(self.frame.width / 2 + 60, 22)
        self.addSubview(right)
        right.handleControlEvent(UIControlEvents.TouchUpInside) { (_) -> Void in
            print("right")
            self.currentIndex += 1
            if self.currentIndex == self.count - 1 {
                self.right.hidden = true
            }
            if self.left == nil {
                self.initLeftButton()
            }else if self.left.hidden {
                self.left.hidden = false
            }
            self.changedAction?(XuTitleViewChangeType.Right)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
