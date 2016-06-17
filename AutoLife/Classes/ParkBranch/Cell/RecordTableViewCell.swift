//
//  RecordTableViewCell.swift
//  AutoLife
//
//  Created by 徐成 on 15/11/9.
//  Copyright © 2015年 徐成. All rights reserved.
//


import UIKit

class RecordTableViewCell: UITableViewCell ,UITableViewDataSource,UITableViewDelegate{
    
    private var luLabel:UILabel!
    private var ldLabel:UILabel!
    private var ruLabel:UILabel!
    private var rdLabel:UILabel!
    private var locateBtn:UIButton!
    private var showButton:UIButton!
    var showDetail = false
    private var record:ParkingRecord?
    lazy var index = 0
    
    var showClosure : (() -> Void)?
    var locationClosure : (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    init(reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        self.initBaseView()
    }
    
    func initBaseView() {
        luLabel = UILabel(frame: CGRectMake(30,5,200,15))
        luLabel.font = AlStyle.font.small
        self.addSubview(luLabel)
        
        ldLabel = UILabel(frame: CGRectMake(30,25,220,15))
        ldLabel.font = AlStyle.font.small
        self.addSubview(ldLabel)
        
        let rs = CGRectGetMaxX(luLabel.frame)
        ruLabel = UILabel(frame: CGRectMake(rs + 10,5,AlStyle.size.width - rs - 25,15))
        ruLabel.font = AlStyle.font.small
        ruLabel.textAlignment = NSTextAlignment.Right
        self.addSubview(ruLabel)
        
        rdLabel = UILabel(frame: CGRectMake(rs + 10,25,AlStyle.size.width - rs - 25,15))
        rdLabel.font = AlStyle.font.small
        rdLabel.textAlignment = NSTextAlignment.Right
        self.addSubview(rdLabel)
        
        locateBtn = UIButton(type: UIButtonType.System)
        locateBtn.frame = CGRectMake(10, 20, 20, 20 * imageOfLocation.size.height / imageOfLocation.size.width)
        locateBtn.setImage(imageOfLocation, forState: UIControlState.Normal)
        locateBtn.addTarget(self, action: #selector(RecordTableViewCell.locationAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(locateBtn)
    }
    
    func initShowButton() {
        let imageName = (showDetail ? "up" : "down")
        showButton = UIButton(type: UIButtonType.System)
        showButton.frame = CGRectMake(0, 0, 115, 15)
        showButton.center = CGPointMake(AlStyle.size.width / 2, self.frame.height - 5)
        showButton.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        showButton.addTarget(self, action: #selector(RecordTableViewCell.shownDonwDetail(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(showButton)
    }
    
    func initDetailView() {
        let view = UIView(frame: CGRectMake(0,50,AlStyle.size.width,1))
        view.backgroundColor = AlStyle.color.gray_light
        self.addSubview(view)
        
        let label = UILabel(frame: CGRectMake(0,60,100,20))
        label.text = "电子收据";label.font = AlStyle.font.small
        label.center.x = AlStyle.size.width / 2
        label.textAlignment = NSTextAlignment.Center
        self.addSubview(label)
        
        let tableView = UITableView(frame: CGRectMake(5, 80, AlStyle.size.width - 10, 25 * CGFloat(9 + record!.chargeStandard.count)))
        tableView.rowHeight = 25;tableView.scrollEnabled = false
        tableView.backgroundColor = UIColor.clearColor()
        tableView.delegate = self
        tableView.dataSource = self
        self.addSubview(tableView)
    }
    
    func setupData(xdic:NSDictionary) {
        luLabel.text = "\(xdic.objectForKey("plate")!)  \(xdic.objectForKey("date")!)"
        ldLabel.text = "\(xdic.objectForKey("address")!)"
        ruLabel.text = "\(xdic.objectForKey("totalTime")!)"
        rdLabel.text = "\(xdic.objectForKey("cost")!)"
        if (xdic.allKeys as NSArray).containsObject("bill") {
            self.record = ParkingRecord(xdic: (xdic.objectForKey("bill") as? NSDictionary)!)
            self.frame.size.height = 90 + 25 * CGFloat(9 + record!.chargeStandard.count)
            self.initDetailView()
            showDetail = true
        }else {
            self.frame.size.height = 52
        }
        self.initShowButton()
    }
    
    func locationAction(sender:UIButton) {
        self.locationClosure?()
    }
    
    func shownDonwDetail(sender:UIButton) {
        self.showClosure?()
    }
    
    //MARK: -- UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.record != nil else {return 0}
        return record!.dic.count + record!.chargeStandard.count - 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
            cell?.backgroundColor = UIColor.clearColor()
        }
        let key = self.record?.KEYS[indexPath.row]
        cell?.textLabel?.text = self.record?.CHI[indexPath.row] as? String
        cell?.textLabel?.font = AlStyle.font.small
        let value = self.record!.dic.objectForKey(key as! String)
        if let v = value as? String {
            cell?.detailTextLabel?.text =  v
        }else if let v = value as? NSArray {
            cell?.detailTextLabel?.text = v[index] as? String
            index += 1
        }
        cell?.detailTextLabel?.textColor = UIColor.blackColor()
        cell?.detailTextLabel?.font = AlStyle.font.small
        if indexPath.row == tableView.numberOfRowsInSection(indexPath.section) - 1 {
            self.index = 0
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        cell?.separatorInset = UIEdgeInsetsMake(0, 0, 0, 15)
        return cell!
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
