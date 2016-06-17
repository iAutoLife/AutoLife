//
//  BrandViewController.swift
//  AutoLife
//
//  Created by xubupt218 on 16/1/20.
//  Copyright © 2016年 徐成. All rights reserved.
//

import UIKit

class BrandViewController: UIViewController  ,UITableViewDelegate,UITableViewDataSource,BrandPickerDelegate{
    
    private var tableView:UITableView!
    
    var brandJSON:JSON = JSON.null
    
    var letters:[String]?
    
    var indexsView:XuIndexView!
    
    private var nav:UINavigationController?
    lazy private var pickerBrandVC:PickerViewController = {
        let pvc = PickerViewController()
        pvc.delegate = self
        pvc.view.frame = CGRectMake(45,0,AlStyle.size.width - 45,AlStyle.size.height)
        pvc.backgroundView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(BrandViewController.tapBackViewGesture(_:))))
        return pvc
    }()
    
    private var sindex:(Int,Bool) = (0,false)
    
    var superVC:NewAutoViewController?
    
    var selectedBrand:((String,String)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "选择车型"
        
        tableView = UITableView(frame: CGRectMake(0, 0, AlStyle.size.width, AlStyle.size.height + 10),style: UITableViewStyle.Grouped)
        self.view.addSubview(tableView)
        XuSetup(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BrandViewController.goback(_:)))
        
        self.navigationController?.title = "选择车型"
    }
    
    override func viewDidAppear(animated: Bool) {
        self.indexsView.setSelectedIn(0, selected: true)
    }
    
    func goback(sender:UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func setLetter(letter:[String]) {
        indexsView = XuIndexView(indexs: letter)
        self.view.addSubview(indexsView)
        indexsView.center = CGPointMake(AlStyle.size.width - 20, AlStyle.size.height / 2 + 20)
        indexsView.selectIndex = { (index) in
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: index), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
            self.sindex.1 = (index == self.letters!.count - 1 ? true : false)
            //取消选中当前index
            self.indexsView.setSelectedIn(self.sindex.0, selected: false)
        }
    }
    
    //MARK:--UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return brandJSON.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let value = self.brandJSON[section]
        let array = value.dictionary?.values.first?.array
        guard array != nil else {return 0}
        return array!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as? Brandcell
        if cell == nil {
            cell = Brandcell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        }
        let value = self.brandJSON[indexPath.section]
        let array = value.dictionary?.values.first?.array
        let dic = array![indexPath.row]
        cell?.imageVV.setImageWithURL(dic["logo"].stringValue, placeholderImage: UIImage(named: "logo")!)
        cell?.label.text = dic["make_name"].stringValue
        cell?.brand = ("\(dic["id"].int!)",cell!.label.text!)
        return cell!
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: tableView.rectForHeaderInSection(section))
        let label = UILabel(frame: CGRectMake(20,0,30,view.frame.height))
        label.text = self.letters?[section]
        return view
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        XutableView(tableView, willDisplayCell: cell, forRowIndexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? Brandcell {
            self.superVC?.brand = ("\(cell.brand.0)","\(cell.brand.1)")
            XuAlamofire.getJSON(uHeader + "auto/brand.second?id=\(cell.brand.0)", success: { (xjson) -> Void in
                self.pickerBrandVC.navigationItem.title = cell.brand.1
                self.showSubBrandView(xjson)
                }, failed: { (error) -> Void in
                    let xhud = MBProgressHUD();self.view.addSubview(xhud)
                    xhud.show(true)
                    xhud.labelText = "请求失败"
                    xhud.hide(true, afterDelay: 1)
            })
        }
    }
    
    //监听滑动位置
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let indexPath = tableView.indexPathForRowAtPoint(CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y + 64))
        guard indexPath != nil else {return}
        if indexPath?.section != sindex.0 {
            indexsView.setSelectedIn(sindex.0,selected: false)
            indexsView.setSelectedIn(indexPath!.section,selected: true)
            sindex.0 = indexPath!.section
        }
    }
    
    //MARK:-- others
    func showSubBrandView(xjson:JSON?) {
        pickerBrandVC.brandJSON = xjson!            //model_name
        if nav == nil {
            nav = UINavigationController(rootViewController: pickerBrandVC)
            nav!.view.frame = CGRectMake(45,0,AlStyle.size.width - 45,AlStyle.size.height)
            nav!.view.center.x += AlStyle.size.width
        }
        self.navigationController?.view.addSubview(pickerBrandVC.backgroundView!)
        self.navigationController?.view.addSubview(nav!.view)
        UIView.animateKeyframesWithDuration(0.6, delay: 0, options: UIViewKeyframeAnimationOptions.CalculationModeCubic, animations: { () -> Void in
            self.nav!.view.transform = CGAffineTransformMakeTranslation( -AlStyle.size.width, 0)
            self.pickerBrandVC.backgroundView?.alpha = 0.6
            }, completion: nil)
    }
    
    func hideSubBrandView(completion:((Bool)->Void)?) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.pickerBrandVC.backgroundView?.alpha = 0
            self.nav?.view.transform = CGAffineTransformIdentity
            }, completion: completion)
    }
    
    func tapBackViewGesture(sender:UITapGestureRecognizer?) {
        self.hideSubBrandView { (isFinished) -> Void in
            guard isFinished else {return}
            self.nav?.view.removeFromSuperview()
            self.pickerBrandVC.backgroundView?.removeFromSuperview()
        }
    }
    
    //MARK:--BrandPickerDelegate
    func brandPickerDidFinish(id: String, brand: String, hasNext: Bool) {
        if hasNext {
            XuAlamofire.getJSON(uHeader + "auto/brand.third?id=\(id)", success: { (xjson) -> Void in
                self.hideSubBrandView({ (isFinished) -> Void in
                    guard isFinished else {return}
                    self.showSubBrandView(xjson)
                    self.pickerBrandVC.navigationItem.title = brand
                })
                }, failed: { (error) -> Void in
                    let xhud = MBProgressHUD();self.nav?.view.addSubview(xhud)
                    xhud.show(true)
                    xhud.labelText = "请求失败"
                    xhud.hide(true, afterDelay: 1)
            })
            let brandID = (id == "" ? superVC!.brand.0 : id)
            superVC?.brand = (brandID,brand)
        }else {
            let brandID = (id == "" ? superVC!.brand.0 : id)
            superVC?.brand = (brandID,superVC!.brand.1 + " " + brand)
            self.hideSubBrandView({ (isFinished) -> Void in
                guard isFinished else {return}
                self.navigationController?.popToRootViewControllerAnimated(true)
            })
        }
    }
    
    func brandPickerDidGoback() {
        self.hideSubBrandView { (_) -> Void in
            self.tableView(self.tableView, didSelectRowAtIndexPath: self.tableView.indexPathForSelectedRow!)
        }
    }
    
    func brandPickerDidCancel() {
        self.tapBackViewGesture(nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


class Brandcell: UITableViewCell {
    
    var imageVV:UIImageView!
    var label:UILabel!
    var brand = ("","")
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: "indexCell")
        imageVV = UIImageView(frame: CGRectMake(15,0,27,27))
        imageVV.center = CGPointMake(30, self.center.y)
        self.contentView.addSubview(imageVV)
        self.backgroundColor = UIColor.clearColor()
        
        label = UILabel(frame: CGRectMake(45,0,200,22))
        self.contentView.addSubview(label)
        label.font = AlStyle.font.normal
        label.center.y = self.center.y
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
