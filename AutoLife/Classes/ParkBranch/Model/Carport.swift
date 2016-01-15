//
//  Carport.swift
//  AutoLife
//
//  Created by 徐成 on 15/11/9.
//  Copyright © 2015年 徐成. All rights reserved.
//

import UIKit

class Carport: NSObject {
    
    var title:String?
    var isrent = false
    var payway:String?
    var revenue:String?
    var shares:NSArray?
    
    init(dict:NSDictionary) {
        for (key,value) in dict {
            switch (key as! String,value) {
            case ("title",_):
                title = value as? String
            case ("revenue",_):
                revenue = value as? String
            case ("info",_):
                if let dic = value as? NSDictionary {
                    for (k,v) in dic {
                        switch (k as! String,v) {
                        case ("isrent",_):
                            isrent = v.boolValue
                        case ("payway",_):
                            payway = v as? String
                        default:break
                        }
                    }
                }
            case ("shares",_):
                shares = value as? NSArray
            default:break
            }
        }
    }
    
    func dictionaryValue() -> NSDictionary {
        let mdic:NSMutableDictionary = [:];
        let dic:NSMutableDictionary = [:]
        mdic.setObject(self.title!, forKey: "title")
        mdic.setObject(self.revenue!, forKey: "revenue")
        mdic.setObject(self.shares!, forKey: "shares")
        dic.setObject(self.isrent, forKey: "isrent")
        if self.payway != nil {
            dic.setObject(self.payway!, forKey: "payway")
        }
        mdic.setObject(dic, forKey: "info")
        return mdic
    }

}
