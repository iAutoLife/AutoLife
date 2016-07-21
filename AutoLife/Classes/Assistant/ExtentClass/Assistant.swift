//
//  Assistant.swift
//  AutoLife
//
//  Created by xubupt218 on 16/1/18.
//  Copyright © 2016年 徐成. All rights reserved.
//

import UIKit

let XuCurrentUser = "XuCurrentUser"
let NotificationOfHideSubMaster = "NotificationOfHideSubMaster"
let imageOfLocation = UIImage(named: "location")!

//MARK:-- const value
let XuAPIKey = "10eabbd5c1ac8b87c03f784286d27e95"

class Assistant: NSObject {
    
    class func alertHint(title:String?,message:String?)->UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "好的", style: UIAlertActionStyle.Cancel, handler: nil))
        return alert
    }
    
    
    class func getShowedViewController() -> UIViewController {
        var window = UIApplication.sharedApplication().keyWindow
        if window?.windowLevel != UIWindowLevelNormal {
            for wind in UIApplication.sharedApplication().windows {
                if wind.windowLevel == UIWindowLevelNormal {
                    window = wind
                    break
                }
            }
        }
        print(object_getClass(window))
        print(object_getClass(window?.subviews[0].nextResponder()))
        if let nextResponder = window?.subviews[0].nextResponder() as? UIViewController {
            return nextResponder
        }
        return window!.rootViewController!.presentedViewController!
    }
}
