//
//  AlTouch.swift
//  iAutoLife
//
//  Created by XuBupt on 16/4/28.
//  Copyright © 2016年 xubupt218. All rights reserved.
//

import UIKit
import LocalAuthentication

class AlTouch: NSObject {
    
    static var isTouchIdAvailable:Bool {
        let authenticationContext = LAContext()
        var error: NSError?
        let isTouchIdAvailable = authenticationContext.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics,
                                                                         error: &error)
        return isTouchIdAvailable
    }
    
    static func touchIdentfy(reply: ((Bool, NSError?) -> Void)?) {
        if (reply != nil) {
            LAContext().evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "需要验证您的指纹来确认您的身份信息", reply: reply!)
        }
    }

}
/*
 typedef NS_ENUM(NSInteger, LAError)
 {
 //用户验证没有通过，比如提供了错误的手指的指纹
 LAErrorAuthenticationFailed = kLAErrorAuthenticationFailed,
 
 // 用户取消了Touch ID验证
 LAErrorUserCancel           = kLAErrorUserCancel,
 
 //用户不想进行Touch ID验证，想进行输入密码操作
 LAErrorUserFallback         = kLAErrorUserFallback,
 
 // 系统终止了验证
 LAErrorSystemCancel         = kLAErrorSystemCancel,
 
 // 用户没有在设备Settings中设定密码
 LAErrorPasscodeNotSet       = kLAErrorPasscodeNotSet,
 
 // 设备不支持Touch ID
 LAErrorTouchIDNotAvailable  = kLAErrorTouchIDNotAvailable,
 
 // 设备没有进行Touch ID 指纹注册
 LAErrorTouchIDNotEnrolled   = kLAErrorTouchIDNotEnrolled,
 } NS_ENUM_AVAILABLE(10_10, 8_0);
 */