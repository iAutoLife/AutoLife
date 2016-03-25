//
//  XuTableViewSetting.swift
//  AutoLife
//
//  Created by 徐成 on 16/1/15.
//  Copyright © 2016年 徐成. All rights reserved.
//


import Foundation
import UIKit

func XutableView(tableView:UITableView,willDisplayCell cell:UITableViewCell,forRowIndexPath indexPath:NSIndexPath) {
    let layer = CAShapeLayer();
    let pathRef = CGPathCreateMutable()
    let bounds = CGRectInset(cell.bounds, 10, 0)
    if indexPath.row == 0 && indexPath.row == tableView.numberOfRowsInSection(indexPath.section) - 1 {
        CGPathAddRoundedRect(pathRef, nil, bounds, XuCornerRadius, XuCornerRadius)
    }else if indexPath.row == 0 {   //起点1--2--3，--3--4，终点4
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds))
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMinY(bounds), XuCornerRadius)
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), XuCornerRadius)
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds))
    }else if indexPath.row == tableView.numberOfRowsInSection(indexPath.section) - 1 {
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds))
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), XuCornerRadius)
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMinY(bounds), XuCornerRadius)
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds))
    }else {
        CGPathAddRect(pathRef, nil, bounds)
    }
    layer.path = pathRef
    layer.fillColor = XuColorWhite.CGColor
    let lineLayer = CALayer();let lineHeight = 1 / UIScreen.mainScreen().scale
    lineLayer.frame = CGRectMake(CGRectGetMinX(bounds), bounds.size.height - lineHeight, bounds.size.width, lineHeight)
    lineLayer.backgroundColor = XuColorGrayThin.CGColor
    layer.addSublayer(lineLayer)
    cell.layer.insertSublayer(layer, atIndex: 0)
}

func XutableView(tableView:UITableView,willDisplayCell cell:UITableViewCell,forRowIndexPath indexPath:NSIndexPath,leftShft:CGFloat) {
    let layer = CAShapeLayer();
    let pathRef = CGPathCreateMutable()
    let bounds = CGRectInset(cell.bounds, 10, 0)
    if indexPath.row == 0 && indexPath.row == tableView.numberOfRowsInSection(indexPath.section) - 1 {
        CGPathAddRoundedRect(pathRef, nil, bounds, XuCornerRadius, XuCornerRadius)
    }else if indexPath.row == 0 {   //起点1--2--3，--3--4，终点4
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds))
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMinY(bounds), XuCornerRadius)
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), XuCornerRadius)
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds))
    }else if indexPath.row == tableView.numberOfRowsInSection(indexPath.section) - 1 {
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds))
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), XuCornerRadius)
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMinY(bounds), XuCornerRadius)
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds))
    }else {
        CGPathAddRect(pathRef, nil, bounds)
    }
    layer.path = pathRef
    layer.fillColor = XuColorWhite.CGColor
    let lineLayer = CALayer();let lineHeight = 1 / UIScreen.mainScreen().scale
    lineLayer.frame = CGRectMake(CGRectGetMinX(bounds) + leftShft, bounds.size.height - lineHeight, bounds.size.width - leftShft, lineHeight)
    lineLayer.backgroundColor = XuColorGrayThin.CGColor
    layer.addSublayer(lineLayer)
    let testView = UIView(frame: bounds)
    testView.layer.insertSublayer(layer, atIndex: 0)
    testView.backgroundColor = UIColor.clearColor()
    cell.backgroundView = testView
}

func XuSetup(tableView:UITableView) {
    tableView.sectionFooterHeight = 0
    tableView.rowHeight = 50
    tableView.delaysContentTouches = false
    tableView.separatorInset = UIEdgeInsetsZero
    tableView.layer.borderWidth = 10
    tableView.layer.cornerRadius = 15
    tableView.layer.borderColor = XuColorGrayThin.CGColor
    tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    tableView.backgroundColor = XuColorGrayThin
    tableView.separatorColor = XuColorGrayThin
}