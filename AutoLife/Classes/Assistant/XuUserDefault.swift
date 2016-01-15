//
//  XuUserDefault.swift
//  ShareAndNav
//
//  Created by 徐成 on 15/11/4.
//  Copyright © 2015年 徐成. All rights reserved.
//

import UIKit

struct XuUserDefaultContants {
    static var password:String = "password"
    static var currentUser:String = "recentUser"
    static var allUser:String = "allUser"
    static var passwordStatus:String = "passwordStatus"
}

class XuUserDefault: NSObject {
    
    class func set(value:String,forkey key:String) {
        let user:NSUserDefaults? = NSUserDefaults.standardUserDefaults()
        if (user != nil) {
            user?.setObject(value, forKey: key)
            user?.synchronize()
            
        }
    }
    
    class func setCurrentUser(currentUser:String) {
        let user:NSUserDefaults? = NSUserDefaults.standardUserDefaults()
        if (user != nil) {
            user?.setObject(currentUser, forKey: XuUserDefaultContants.currentUser)
            user?.synchronize()
        }
    }
    
    class func setStatusOfPassword(statusBoolValue:Bool) {
        let user:NSUserDefaults? = NSUserDefaults.standardUserDefaults()
        if (user != nil) {
            user?.setObject(statusBoolValue, forKey: XuUserDefaultContants.passwordStatus)
            user?.synchronize()
        }
    }
    
    class func setDictionary(xDictionary:NSDictionary,forkey key:String) {
        let user:NSUserDefaults? = NSUserDefaults.standardUserDefaults()
        if (user != nil) {
            user?.setObject(xDictionary, forKey: key)
            user?.synchronize()
        }
        
    }
    
    //MARK: --GET
    class func get(key:String) -> AnyObject? {
        return NSUserDefaults.standardUserDefaults().objectForKey(key)
    }
    
    class func getCurrentUser() -> String? {
        return NSUserDefaults.standardUserDefaults().stringForKey(XuUserDefaultContants.currentUser)
    }
    
    class func getStatusOfPassword() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey(XuUserDefaultContants.passwordStatus)
    }
    
    class func getDictionary(key:String) -> NSDictionary? {
        return NSUserDefaults.standardUserDefaults().dictionaryForKey(key)
    }
    
    static func getCurrentUserInfo(user_id:String) -> NSDictionary {
        let value = NSUserDefaults.standardUserDefaults().dictionaryForKey(user_id)
        if value != nil {
            return value!
        }
        return [:]
    }
}
