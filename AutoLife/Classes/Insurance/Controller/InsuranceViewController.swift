//
//  InsuranceViewController.swift
//  AutoLife
//
//  Created by xubupt218 on 16/3/21.
//  Copyright © 2016年 徐成. All rights reserved.
//

import UIKit

class InsuranceViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,ColTableViewCellDelegate{
    
    private var headView3:SegHeadView!
    private var tableView:UITableView!
    private var beauty:(CGFloat,CGFloat,CGFloat) = (0,0,0)
    private var rightItemBtn:UIButton!
    private var speed = 0
    
    private let sec3Info = ["安心旅游综合意外伤害险A    ¥5.00","安心旅游综合意外伤害险B    ¥15.00","安心旅游综合意外伤害险C    ¥25.00","畅游神州-自由行A","畅游神州-自由行B","畅游神州-自由行C","安心旅游综合意外伤害险A    ¥5.00","安心旅游综合意外伤害险B    ¥15.00","安心旅游综合意外伤害险C    ¥25.00","畅游神州-自由行A","畅游神州-自由行B","畅游神州-自由行C","畅游神州-自由行A","畅游神州-自由行B","畅游神州-自由行C"]
    private let sec3Infos = ["3天  意外5万|疾病身故2.5万|医疗0.5万|丧葬2万","7天  意外5万|疾病身故12.5万|医疗1.5万|丧葬1万","14天  意外15万|疾病身故21.5万|医疗10.5万|丧葬3万","3天  意外身故/伤残12.5万|意外医疗1.5万|丧葬2万","7天  意外身故/伤残21.5万|医疗2.5万|丧葬11万","14天  意外身故/伤残22.5万|医疗7.5万|丧葬11万","3天  意外5万|疾病身故2.5万|医疗0.5万|丧葬2万","7天  意外5万|疾病身故12.5万|医疗1.5万|丧葬1万","14天  意外15万|疾病身故21.5万|医疗10.5万|丧葬3万","3天  意外身故/伤残12.5万|意外医疗1.5万|丧葬2万","7天  意外身故/伤残21.5万|医疗2.5万|丧葬11万","14天  意外身故/伤残22.5万|医疗7.5万|丧葬11万","7天  意外身故/伤残21.5万|医疗2.5万|丧葬11万","14天  意外身故/伤残22.5万|医疗7.5万|丧葬11万","14天  意外身故/伤残22.5万|医疗7.5万|丧葬11万"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "保险"
        self.headView3 = SegHeadView(title: nil, segs: ["阳  光","人  保","平  安","太平洋","人  寿","其  他"])
        // Do any additional setup after loading the view.
        tableView = UITableView(frame: CGRectMake(0, 0, XuWidth, XuHeight + 10),style: UITableViewStyle.Plain)
        self.view.addSubview(tableView)
        XuSetup(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(SunTableViewCell.self, forCellReuseIdentifier: "sCell")
        tableView.registerNib(UINib(nibName: "SunTableViewCell", bundle: nil), forCellReuseIdentifier: "sCell")
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .Plain, target: self, action: "back:")
    }
    
    func back(sender:UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: --UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0,1:return 1
//        case 1:return 1
        default:return 1
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:return 55
        case 1:return 5
        case 2:return 60
        default:return 0
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:return SegHeadView(title: "我的车险保单", segs: ["京AB1212","京P2C8T4","+添加车险"])
        case 2:
            return headView3
        default:return nil
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 30
        }else if section == 2 {
            return 10
        }
        return 0
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == 1 else {return nil}
        let rect = tableView.rectForFooterInSection(section)
        self.beauty = (rect.origin.y,rect.height,rect.height - 64)
        return FooterView()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 95
        }else if indexPath.section == 2 {
            return 60 * CGFloat(sec3Info.count)
        }
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("sCell", forIndexPath: indexPath) as? SunTableViewCell
            cell?.setData()
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell?.backgroundColor = UIColor.clearColor()
            return cell!
        case 1:
            var cell = tableView.dequeueReusableCellWithIdentifier("1cell")
            if cell == nil {
                cell = UITableViewCell(style: .Value1, reuseIdentifier: "1cell")
                cell?.backgroundColor = UIColor.clearColor()
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            let atext = NSMutableAttributedString(string: "综合意外伤害险(至2016-11-11)")
            atext.addAttributes([NSFontAttributeName:UIFont.systemFontOfSize(XuTextSizeMiddle)], range: NSMakeRange(0, 7))
            atext.addAttributes([NSFontAttributeName:UIFont.systemFontOfSize(XuTextSizeSmall),NSForegroundColorAttributeName:XuColorGray], range: NSMakeRange(7, atext.length - 7))
            cell?.textLabel?.attributedText = atext
            cell?.detailTextLabel?.text = "王麻子 10万 1份  ¥5.00"
            cell?.detailTextLabel?.font = UIFont.systemFontOfSize(XuTextSizeSmall)
            return cell!
        case 2:
            var cell = tableView.dequeueReusableCellWithIdentifier("1cell") as? ColTableViewCell
            if cell == nil {
                cell = ColTableViewCell(datas: NSMutableArray(objects: sec3Info,sec3Infos))
                cell?.backgroundColor = UIColor.clearColor()
                cell?.delegate = self
            }
            headView3.indexChangeBlock = { (index) in
                cell?.colScrollToItem(index)
            }
            return cell!
        default:return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        XutableView(tableView, willDisplayCell: cell, forRowIndexPath: indexPath)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let relativeLocation = scrollView.contentOffset.y - beauty.0 + 64
        if beauty.0 == 0 {
            return
        }else if relativeLocation > 10 && self.navigationItem.title == "保险" {
            self.navigationItem.title = "旅行随时保"
            rightItemBtn = UIButton(type: UIButtonType.Custom)
            rightItemBtn.setImage(UIImage(named: "shopping_cart"), forState: UIControlState.Normal)
            rightItemBtn.frame = CGRectMake(0, 0, 30, 30)
            rightItemBtn.alpha = 0.3
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightItemBtn)
            rightItemBtn.handleControlEvent(.TouchUpInside) { (_) -> Void in
                print("rightItemBtn")
            }
        }else if relativeLocation < 0 && self.navigationItem.title == "旅行随时保" {
            self.navigationItem.title = "保险"
            self.navigationItem.rightBarButtonItem = nil
        }
        if fabs(relativeLocation - beauty.1) < 10  {
        }
    }
    
    //MARK:--ColTableViewCellDelegate
    func colItemDidChanged(index: Int) {
        self.headView3.seg.selectedSegmentIndex = index
    }
    
    func colItemCellDidSelected(row: Int) {
        
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
