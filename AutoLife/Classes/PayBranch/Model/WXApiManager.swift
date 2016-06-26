//
//  WXApiManager.swift
//  AutoLife
//
//  Created by XuBupt on 16/6/25.
//  Copyright © 2016年 徐成. All rights reserved.
//

import UIKit

class WXApiManager: NSObject ,WXApiDelegate{
    
    
    static var sharedManager:WXApiManager = {
        var once:dispatch_once_t = 0
        var xpay:WXApiManager!
        dispatch_once(&once, { () -> Void in
            xpay = WXApiManager()
        })
        return xpay
    }()
    
    func onResp(resp: BaseResp!) {
        if resp is PayResp {
            print("支付结果-errCode:\(resp.errCode)-errStr:\(resp.errStr)")
            if resp.errCode == 0 {
                UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(Assistant.alertHint("支付结果", message: "支付成功"), animated: true, completion: nil)
            }else {
                let message = (resp.errCode == -2 ? "支付已取消" : "支付出错")
                UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(Assistant.alertHint("支付结果", message: message), animated: true, completion: nil)
            }
        }else if let authResp = resp as? SendAuthResp {
            print("code:\(authResp.code)\nstate:\(authResp.state)\nlang:\(authResp.lang)\ncountry:\(authResp.country)")
        }
    }
    
}
