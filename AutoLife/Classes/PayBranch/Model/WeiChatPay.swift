//
//  WeiChatPay.swift
//  AutoLife
//
//  Created by XuBupt on 16/6/22.
//  Copyright © 2016年 徐成. All rights reserved.
//

import UIKit

class WeiChatPay: NSObject{

    class func jumpToBizPay() { //"http://139.129.110.224/CarManageSystem/weixin/pay"
        let url = "http://139.129.110.224/CarManageSystem/weixin/pay"
        XuAlamofire.getJSON(url, success: { (json) in
            print(json)
            if json!["err_code"] == nil {
                let payReq = PayReq()
                print(json!["package"].string!)
                print(json!["noncestr"].string)
                payReq.partnerId = json!["partnerid"].string!
                payReq.prepayId = json!["prepayid"].string!
                payReq.nonceStr = json!["noncestr"].string!
                payReq.timeStamp = UInt32(NSString(string: json!["timestamp"].string!).intValue)
                payReq.package = json!["package"].string!
                payReq.sign = json!["sign"].string!
                WXApi.sendReq(payReq)
            }else if json!["err_code"].string! == "ORDERPAID" {
                UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(Assistant.alertHint("支付结果", message: "\(json!["err_code_des"].string!)"), animated: true, completion: nil)
            }
        }) { (error, flag) in
        }
    }
    
    class func doWXPayPost(parameters:[String:AnyObject]?,payClosure:((Bool) -> Void)?) {
        let url = AlStyle.uHeader + "pay/order"
        //"http://10.104.5.172:8080/CarManageSystem/payment/weixin.park"
        XuAlamofire.postParameters(url, parameters: parameters, successWithJSON: { (json) in
            print(json)
            if json!["err_code"] == nil {
                let payReq = PayReq()
                print(json!["package"].string!)
                print(json!["noncestr"].string)
                payReq.partnerId = json!["partnerid"].string!
                payReq.prepayId = json!["prepayid"].string!
                payReq.nonceStr = json!["noncestr"].string!
                payReq.timeStamp = UInt32(NSString(string: json!["timestamp"].string!).intValue)
                payReq.package = json!["package"].string!
                payReq.sign = json!["sign"].string!
                WXApiManager.sharedManager.payClosure = payClosure
                WXApi.sendReq(payReq)
            }else if json!["err_code"].string! == "ORDERPAID" {
                UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(Assistant.alertHint("支付结果", message: "\(json!["err_code_des"].string!)"), animated: true, completion: nil)
            }
            }) { (error, flag) -> Void? in
                payClosure?(flag)
        }
    }
    
    
    
    class func authorizationToLogin(viewController:LoginViewController) -> Bool {
        guard WXApi.isWXAppInstalled() else {return false}
        let authorizationReq = SendAuthReq()
        authorizationReq.scope = "snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"
        authorizationReq.openID = "wxdd6af3fdcbde0c2a"
        authorizationReq.state = "xucheng"
        return WXApi.sendAuthReq(authorizationReq, viewController: viewController, delegate: viewController)//WXApiManager.sharedManager)
    }
    
}
