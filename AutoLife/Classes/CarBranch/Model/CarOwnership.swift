//
//  CarOwnership.swift
//  AutoLife
//
//  Created by 徐成 on 15/11/6.
//  Copyright © 2015年 徐成. All rights reserved.
//

import UIKit

class CarOwnership: NSObject {
    
    var brand:String?
    var plate:String?
    var isCerificate:Bool?
    var isAuthorize:Bool?
    var assistPhones:NSArray?
    
    init(dic:NSDictionary) {
        for (key,value) in dic {
            switch (key as! String,value) {
            case ("brand",_):
                brand = value as? String
            case ("plate",_):
                plate = value as? String
            case ("cerificate",_):
                isCerificate = value.boolValue
            case ("authorize",_):
                isAuthorize = value.boolValue
            case ("assist",_):
                assistPhones = value as? NSArray
            default:break
            }
        }
    }
    
    init(xco:CarOwnership) {
        self.brand = xco.brand
        self.plate = xco.plate
        self.isCerificate = xco.isCerificate
        self.isAuthorize = xco.isAuthorize
        self.assistPhones = xco.assistPhones
    }
    
    func dictionaryValue() -> NSDictionary {
        let mdic:NSMutableDictionary = [:]
        mdic.setObject(self.brand!, forKey: "brand")
        mdic.setObject(self.plate!, forKey: "plate")
        mdic.setObject(self.isAuthorize!, forKey: "authorize")
        if self.isCerificate != nil {
            mdic.setObject(self.isCerificate!, forKey: "cerificate")
        }
        if self.assistPhones != nil {
            mdic.setObject(self.assistPhones!, forKey: "assist")
        }
        return mdic
    }
}


class ParkingRecord: NSObject {
    var payWay:String!
    var enter:String!
    var coupon:String!
    var totalTime:String!
    var parkTime:String!
    var parking:String!
    var fee:String!
    var plate:String!
    var exit:String!
    var dic:NSDictionary!
    var chargeStandard:NSArray!
    
    var KEYS:NSMutableArray = ["parkTime","totalTime","plate","fee","parking","enter","exit","chargeStandard","coupon","payway"]
    var CHI:NSMutableArray = ["停车时间","总时长","车牌号","收费","停车场","入口","出口","收费标准","优惠","支付方式"]
    
    init(xdic:NSDictionary) {
        dic = xdic
        for (key,value) in xdic {
            switch (key as! String,value) {
            case ("payWay",_):
                payWay = value as? String
            case ("plate",_):
                plate = value as? String
            case ("enter",_):
                enter = value as? String
            case ("coupon",_):
                coupon = value as? String
            case ("chargeStandard",_):
                chargeStandard = value as? NSArray
                if chargeStandard.count > 1{
                    var i = chargeStandard.count - 1
                    while(i-- != 0) {
                        self.CHI.insertObject("", atIndex: 8)
                        self.KEYS.insertObject("chargeStandard", atIndex: 7)
                    }
                }

            case ("totalTime",_):
                totalTime = value as? String
            case ("parkTime",_):
                parkTime = value as? String
            case ("parking",_):
                parking = value as? String
            case ("fee",_):
                fee = value as? String
            case ("exit",_):
                exit = value as? String
            default:break
            }
        }
    }
}
