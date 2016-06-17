//
//  XuPickerView.swift
//  AutoLife
//
//  Created by 徐成 on 15/11/9.
//  Copyright © 2015年 徐成. All rights reserved.
//

import UIKit

enum XuPickerStyle {
    case Time,Date,DateAndTime,Provinces,CityAndArea,City
}

@objc protocol XuPickerViewDelegate {
    func XuPickerViewDidCancel()
    func XuPickerViewDidSelected(pickerString:String)
    optional func XupickerViewDidChanged(pickerString:String)
}

struct Locate {
    var province:String = ""
    var city:String = ""
    var area:String = ""
}

class XuPickerView: UIView ,UIPickerViewDataSource,UIPickerViewDelegate{
    
    private var cities:NSArray?
    private var areas:NSArray?
    lazy var datePicker = UIDatePicker()
    var pickerView:UIPickerView?
    let rectPicker = CGRectMake(0, 44, AlStyle.size.width, AlStyle.size.height / 3 - 45)
    var pathArray:NSArray?
    var delegate:XuPickerViewDelegate?
    lazy var component = 3;lazy var row0 = 0;lazy var row1 = 0
    lazy var addressString:NSMutableString = "北京 通州"
    var locate:Locate = Locate()

    init(style:XuPickerStyle) {
        super.init(frame: CGRectMake(0, 0, AlStyle.size.width, AlStyle.size.height / 3))
        self.layer.borderColor = AlStyle.color.gray_light.CGColor
        self.layer.borderWidth = 1
        self.backgroundColor = AlStyle.color.white
        self.initBarView()
        switch style {
        case .Date:
            self.initDatePickerView(UIDatePickerMode.Date)
        case .Time:
            self.initDatePickerView(UIDatePickerMode.Time)
        case .DateAndTime:
            self.initDatePickerView(UIDatePickerMode.DateAndTime)
        case .CityAndArea:
            self.initCustomPickerView()
        case .City:
            self.initCustomPickerView()
            self.component = 2
        case .Provinces:
            self.initCustomPickerView()
            self.component = 1
        }
    }
    
    //MARK: -- init View
    func initCustomPickerView() {
        pickerView = UIPickerView(frame: self.rectPicker)
        pickerView?.dataSource = self
        pickerView?.delegate = self
        pickerView?.showsSelectionIndicator = true
        self.addSubview(pickerView!)
        
        
        let path = NSBundle.mainBundle().pathForResource("CityAndArea", ofType: ".plist")
        self.pathArray = NSArray(contentsOfFile: path!)
    }
    
    func initBarView() {
        let bar = UINavigationBar(frame: CGRectMake(0,0,AlStyle.size.width,44))
        let navItem = UINavigationItem()
        navItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(XuPickerView.cancel(_:)))
        navItem.rightBarButtonItem = UIBarButtonItem(title: "确定", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(XuPickerView.ensure(_:)))
        bar.pushNavigationItem(navItem, animated: false)
        bar.backgroundColor = UIColor.clearColor()
        self.addSubview(bar)
    }
    
    func initDatePickerView(datePickerMode:UIDatePickerMode) {
        datePicker.datePickerMode = datePickerMode
        datePicker.frame = rectPicker
        datePicker.locale = NSLocale(localeIdentifier: "zh_CN")
        datePicker.addTarget(self, action: #selector(XuPickerView.datePickerChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.addSubview(datePicker)
    }
    
    //MARK:--controller action
    func cancel(sender:UIBarButtonItem) {
        self.delegate?.XuPickerViewDidCancel()
        print("cancel")
    }
    
    func ensure(sender:UIBarButtonItem) {
        if pickerView != nil {
            self.getpickerView()
        }else {
            let selectedDate:NSDate = datePicker.date
            let formatter:NSDateFormatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            self.delegate?.XuPickerViewDidSelected(formatter.stringFromDate(selectedDate))
        }
    }
    
    func datePickerChanged(datepicker:UIDatePicker) {
        let selectedDate:NSDate = datePicker.date
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        delegate?.XupickerViewDidChanged!(formatter.stringFromDate(selectedDate))
    }
    
    func getpickerView() {
        self.addressString = NSMutableString(string: pathArray![pickerView!.selectedRowInComponent(0)]["state"] as! String)
        let a = dicWithDic(pathArray![pickerView!.selectedRowInComponent(0)] as! NSDictionary, key: "cities", row: pickerView!.selectedRowInComponent(1))
        self.addressString.appendString(" ")
        self.addressString.appendString(a.objectForKey("city") as! String)
        if let areas = a.objectForKey("areas") as? NSArray {
        if areas.count > 0 {
            self.addressString.appendString(" ")
            self.addressString.appendString(areas.objectAtIndex(pickerView!.selectedRowInComponent(2)) as! String)
            }
        }
        self.delegate?.XuPickerViewDidSelected(addressString as String)
    }
    
    //MARK: --UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            if self.component > 2 {
                self.row0 = row
                self.row1 = 0
                cities = pathArray![row]["cities"] as? NSArray
                pickerView.selectRow(0, inComponent: 1, animated: true)
                pickerView.reloadComponent(1)
                areas = cities![0].objectForKey("areas") as? NSArray
                pickerView.selectRow(0, inComponent: 2, animated: true)
                pickerView.reloadComponent(2)
                
                self.locate.province = self.pathArray![row]["state"] as! String
                self.locate.city = cities?.objectAtIndex(0).objectForKey("city") as! String
                if areas?.count > 0 {
                    self.locate.area = areas![0] as! String
                }else {
                    self.locate.area = ""
                }
            }else if self.component > 1 {
                self.row0 = row
                cities = pathArray![row]["cities"] as? NSArray
                pickerView.selectRow(0, inComponent: 1, animated: true)
                pickerView.reloadComponent(1)
                
                self.locate.province = self.pathArray![row]["state"] as! String
                self.locate.city = cities?.objectAtIndex(0).objectForKey("city") as! String
            }
        case 1:
            if self.component > 2{
                self.row1 = row
                areas = cities![row].objectForKey("areas") as? NSArray
                pickerView.selectRow(0, inComponent: 2, animated: true)
                pickerView.reloadComponent(2)
                self.locate.province = pathArray![pickerView.selectedRowInComponent(0)]["state"] as! String
                self.locate.city = cities![row].objectForKey("city") as! String
                if areas?.count > 0 {
                    self.locate.area = areas![0] as! String
                }else {
                    self.locate.area = ""
                }
            }
        case 2:
            self.locate.province = pathArray![pickerView.selectedRowInComponent(0)]["state"] as! String
            self.locate.city = cities![pickerView.selectedRowInComponent(1)]["city"] as! String
            if areas?.count > 0 {
                self.locate.area = areas![row] as! String
            }else {
                self.locate.area = ""
            }
        default:break
        }
        delegate?.XupickerViewDidChanged?("\(self.locate.province) \(self.locate.city) \(self.locate.area)")
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return self.pathArray!.count
        case 1:
            return (self.pathArray![row0]["cities"] as? NSArray)!.count
        case 2:
            let b = (dicWithDic(pathArray![row0] as! NSDictionary, key: "cities", row: row1)).objectForKey("areas") as? NSArray
            return (b?.count)!
        default:break
        }
        return 0
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return self.component
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let label = UILabel(frame: CGRectMake(0,0,AlStyle.size.width / 3, 20))
        label.font = AlStyle.font.normal
        label.text = self.stringWithRow(row, component: component)
        label.textAlignment = NSTextAlignment.Center
        return label
    }
    
    func dicWithDic(mdic:NSDictionary,key:String,row:Int) -> NSDictionary {
        if let array = mdic[key]! as? NSArray {
            guard array.count > row else {return NSDictionary()}
            if let dic = array[row] as? NSDictionary {
                return dic
            }
        }
        return NSDictionary()
    }
    
    func stringWithRow(row:Int,component:Int) -> String? {
        switch component {
        case 0:
            cities = self.pathArray![row]["cities"] as? NSArray
            return self.pathArray![row]["state"] as? String
        case 1:
            areas = cities![row]["areas"] as? NSArray
            return dicWithDic(self.pathArray![row0] as! NSDictionary, key: "cities", row: row).objectForKey("city") as? String
        case 2:
            if let array = dicWithDic(self.pathArray![row0] as! NSDictionary, key: "cities", row: row1).objectForKey("areas") as? NSArray {
                if array.count == 0 {return ""}
                return array[row] as? String
            }
            return nil
        default:return nil
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
