//
//  CarportTableViewCell.swift
//  AutoLife
//
//  Created by 徐成 on 15/11/9.
//  Copyright © 2015年 徐成. All rights reserved.
//

import UIKit

protocol CarportSharesCellDelegate {
    func CarportAddButtonClicked(cell:UITableViewCell)
    func CarportSwitchChanged(cell:UITableViewCell,boolValue:Bool,index:Int)
}

class CarportTableViewCell: UITableViewCell ,UITableViewDelegate,UITableViewDataSource,UniversalTableViewCellDelegate{
    
    var delegate:CarportSharesCellDelegate?
    private var tableView:UITableView!
    var shares:NSArray = [] {
        didSet{
            self.frame.size.height = XuCellHeight * (1 + CGFloat(shares.count))
            tableView.frame.size.height = CGRectGetHeight(self.frame)
            tableView.reloadData()
        }
    }
    
    init(reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        self.initTableView()
    }
    
    func initTableView() {
        tableView = UITableView(frame: CGRectMake(0, 0, XuWidth, self.frame.height), style: UITableViewStyle.Plain)
        tableView.backgroundColor = UIColor.clearColor()//XuColorGrayThin
        tableView.scrollEnabled = false
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.rowHeight = 50
        
        tableView.dataSource = self
        tableView.delegate = self
        self.contentView.addSubview(tableView)
    }
    
    //MARK: --UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shares.count + 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            var cell = tableView.dequeueReusableCellWithIdentifier("cellb") as? UniversalTableViewCell
            if cell == nil    {
                cell = UniversalTableViewCell(rightObject: self.AddButton(), reuseIdentifier: "cellb")
            }
            cell?.leftLabelText = "车位分享"
            if cell?.rightObject is UIButton {
                (cell!.rightObject as! UIButton).handleControlEvent(UIControlEvents.TouchUpInside, withBlock: { (_) -> Void in
                    self.delegate?.CarportAddButtonClicked(self)
                })
            }
            return cell!
        }else {
            var cell = tableView.dequeueReusableCellWithIdentifier("cells") as? UniversalTableViewCell
            if cell == nil {
                cell = UniversalTableViewCell(universalStyle: UniversalCellStyle.RightSwitch, reuseIdentifier: "cells")
            }
            if let array = self.shares[indexPath.row - 1] as? NSArray {
                cell?.leftLabelText = "\(array[0])  \(array[1])"
                cell?.leftShift = 45
                cell?.rSwitchState = array[2].boolValue
            }
            cell?.backgroundColor = UIColor.clearColor()
            cell?.delegate = self
            return cell!
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let layer = CAShapeLayer()
        let bounds = CGRectInset(cell.bounds, 10, 0)
        layer.fillColor = UIColor.clearColor().CGColor
        let lineLayer = CALayer()
        let lineHeight = 1 / UIScreen.mainScreen().scale
        if indexPath.row == 0 {
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds), bounds.size.height - lineHeight, 135, lineHeight)
        }else {
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds) + 45, bounds.size.height - lineHeight, XuWidth - 45, lineHeight)
        }
        lineLayer.backgroundColor = XuColorGrayThin.CGColor
        layer.addSublayer(lineLayer)
        let testView = UIView(frame: bounds)
        testView.layer.insertSublayer(layer, atIndex: 0)
        testView.backgroundColor = UIColor.clearColor()
        cell.backgroundView = testView
        cell.separatorInset = UIEdgeInsetsMake(50, 0, 50, 0)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    //MARK: --OUTHERS
    func AddButton() -> UIButton{
        let button:UIButton = UIButton(type: UIButtonType.Custom)
        button.setup(UIImage(named: "add"), framesize: CGSizeMake(25, 16))
        return button
    }
    
    func universalRightSwitchChanged(cell: UITableViewCell, boolValue: Bool) {
        let indexPath = self.tableView.indexPathForCell(cell)
        delegate?.CarportSwitchChanged(self, boolValue: boolValue,index: indexPath!.row - 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
