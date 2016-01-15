//
//  ViolationObject.swift
//  AutoLife
//
//  Created by 徐成 on 15/11/6.
//  Copyright © 2015年 徐成. All rights reserved.
//

import UIKit

class ViolationObject: NSObject {
    
    var plate:String?
    var times:NSInteger?
    var points:NSInteger?
    var forfeit:NSInteger?
    var info:NSArray?
    
    init(dic:NSDictionary) {
        for (key,value) in dic {
            switch (key as! String,value) {
            case ("plate",_):
                plate = value as? String
            case ("times",_):
                times = value as? NSInteger
            case ("points",_):
                points = value as? NSInteger
            case ("forfeit",_):
                forfeit = value as? NSInteger
            case ("info",_):
                guard let xar = value as? NSArray else {return}
                if xar.count == 0 {return}
                let infos:NSMutableArray = []
                for ele in xar {
                    guard let dic = ele as? NSDictionary else {return}
                    if dic.count == 0 {return}
                    infos.addObject(Violation(dic: dic))
                }
                info = xar//infos
            default:break
            }
        }
    }
}

class Violation: NSObject {
    
    var address:String?
    var content:String?
    var reason:String?
    var date:String?
    var point:String?
    var forfeit:String?
    var numbers:String?
    
    init(dic:NSDictionary) {
        for (key,value) in dic {
            switch (key as! String,value) {
            case ("address",_):
                address = value as? String
            case ("content",_):
                content = value as? String
            case ("reason",_):
                reason = value as? String
            case ("date",_):
                date = value as? String
            case ("point",_):
                point = value as? String
            case ("forfeit",_):
                forfeit = value as? String
            case ("numbers",_):
                numbers = value as? String
            default:break
            }
        }
    }
    
}
