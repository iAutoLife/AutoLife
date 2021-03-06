//
//  XuIndexView.swift
//  AutoLife
//
//  Created by xubupt218 on 16/1/21.
//  Copyright © 2016年 徐成. All rights reserved.
//

import UIKit

class XuIndexView: UIView ,UITableViewDataSource,UITableViewDelegate{
    private var tableView:UITableView!
    private var indexs:[String] = []
    
    var selectIndex:((Int)->Void)?
    
    init(indexs:[String]) {
        let cHeight = 22 * AlStyle.size.height / 667
        super.init(frame: CGRectMake(0, 0, 20, CGFloat(indexs.count) * cHeight))
        self.indexs = indexs
        tableView = UITableView(frame: self.frame)
        self.addSubview(tableView)
        tableView.layer.cornerRadius = 6
        tableView.layer.borderColor = AlStyle.color.blue_light.CGColor
        tableView.layer.borderWidth = 1
        tableView.dataSource = self;tableView.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.rowHeight = cHeight
        tableView.scrollEnabled = false
    }
    
    func setSelectedIn(index:Int,selected:Bool) {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
        cell?.setSelected(selected, animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return indexs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = Indexcell()
        cell.label.text = indexs[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectIndex?(indexPath.row)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Indexcell: UITableViewCell {
    
    var label:UILabel!
    
    init() {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: "indexCell")
        label = UILabel(frame: CGRectMake(0,0,20,22))
        self.contentView.addSubview(label)
        label.textAlignment = NSTextAlignment.Center
        label.font = AlStyle.font.normal
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        let color = selected ? AlStyle.color.blue :UIColor.blackColor()
        label.textColor = color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
