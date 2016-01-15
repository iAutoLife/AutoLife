//
//  KeyChain.swift
//  LoanerDemo
//
//  Created by 徐成 on 15/7/13.
//  Copyright (c) 2015年 徐成. All rights reserved.
//

import UIKit

extension NSDictionary {
    func dataValue() -> NSData {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(self, forKey: "key")
        archiver.finishEncoding()
        return data
    }
}

extension NSArray {
    func dataValue() -> NSData {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(self, forKey: "key")
        archiver.finishEncoding()
        return data
    }
}

extension NSData {
    func dictionaryValue() -> NSDictionary {
        let unarchiver = NSKeyedUnarchiver(forReadingWithData: NSMutableData(data: self))
        let dictionary = unarchiver.decodeObjectForKey("key") as! NSDictionary
        unarchiver.finishDecoding()
        return dictionary
    }
    
    func arrayValue() -> NSArray {
        let unarchiver = NSKeyedUnarchiver(forReadingWithData: NSMutableData(data: self))
        let array = unarchiver.decodeObjectForKey("key") as! NSArray
        unarchiver.finishDecoding()
        return array
    }
}

struct XuKeyChainConstants {
    static var xClass:String {return toString(kSecClass)}
    static var xClassGenericPW:String {return toString(kSecClassGenericPassword)}
    static var xAttrAcount:String {return toString(kSecAttrAccount)}
    static var xValueData:String {return toString(kSecValueData)}
    static var xReturnData:String {return toString(kSecReturnData)}
    static var xMatchLimit:String {return toString(kSecMatchLimit)}
    static var xAttrAccessGroup:String {return toString(kSecAttrAccessGroup)}
    static var xAccessible:String {return toString(kSecAttrAccessible)}
    
    static func toString(value:CFStringRef) -> String {
        return value as String
    }
}

class KeyChain: NSObject {
    
    
    //MARK: -- NEW
    class func set(value:String ,forkey key:String) -> Bool{
        guard let data = value.dataUsingEncoding(NSUTF8StringEncoding) else {return false}
        KeyChain.remove(key)
        let query = [
            XuKeyChainConstants.xClass       : kSecClassGenericPassword,
            XuKeyChainConstants.xAttrAcount  : " \(key)",
            XuKeyChainConstants.xValueData   : data,
            XuKeyChainConstants.xAccessible  : kSecAttrAccessibleWhenUnlocked]
        return SecItemAdd(query, nil) == noErr
    }
    
    class func setDictionary(xDictionary:NSDictionary,forkey key:String) -> Bool {
        KeyChain.remove(key)
        let query = [
            XuKeyChainConstants.xClass       : kSecClassGenericPassword,
            XuKeyChainConstants.xAttrAcount  : " \(key)",
            XuKeyChainConstants.xValueData   : xDictionary.dataValue(),
            XuKeyChainConstants.xAccessible  : kSecAttrAccessibleWhenUnlocked]
        return SecItemAdd(query, nil) == noErr
    }
    
    class func setArray(xArray:NSArray,forkey key:String) -> Bool {
        KeyChain.remove(key)
        let query = [
            XuKeyChainConstants.xClass       : kSecClassGenericPassword,
            XuKeyChainConstants.xAttrAcount  : " \(key)",
            XuKeyChainConstants.xValueData   : xArray.dataValue(),
            XuKeyChainConstants.xAccessible  : kSecAttrAccessibleWhenUnlocked]
        return SecItemAdd(query, nil) == noErr
    }
    
    class func get(key:String) -> String? {
        guard let data = KeyChain.data(key) else {return nil}
        return NSString(data: (data as NSData), encoding: NSUTF8StringEncoding) as? String
    }
    
    class func getDictionary(key:String) -> NSDictionary? {
        guard let data = KeyChain.data(key) else {return nil}
        return data.dictionaryValue()
    }
    
    class func getArray(key:String) -> NSArray? {
        guard let data = KeyChain.data(key) else {return nil}
        return data.arrayValue()
    }
    
    class func remove(key:String) -> Bool {
        let query:[String:NSObject] = [
            XuKeyChainConstants.xClass       : kSecClassGenericPassword,
            XuKeyChainConstants.xAttrAcount  : " \(key)"]
        return SecItemDelete(query as CFDictionaryRef) == noErr
    }
    
    //MARK: --Assistant
    class func data(key:String) -> NSData? {
        let query = [
            XuKeyChainConstants.xClass       : kSecClassGenericPassword,
            XuKeyChainConstants.xAttrAcount  : " \(key)",
            XuKeyChainConstants.xReturnData  : kCFBooleanTrue,
            XuKeyChainConstants.xMatchLimit  : kSecMatchLimitOne]
        var result : AnyObject?
        let status = withUnsafeMutablePointer(&result) {
            SecItemCopyMatching(query, UnsafeMutablePointer($0))
        }
        return (status == noErr ? result as? NSData : nil)
    }
    
    //MARK: --OLD
    class func SaveKeyChainItem(user_id:NSString,user_password:NSString,IP:NSString) -> Bool {
        let keyChainItem = NSMutableDictionary()
        keyChainItem.setObject(kSecClassInternetPassword as NSString, forKey: kSecClass as NSString)
        keyChainItem.setObject(user_id, forKey: kSecAttrAccount as NSString)

        if SecItemCopyMatching(keyChainItem,nil) == noErr{
            return false
        }else{
            keyChainItem.setObject(user_password.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion:true)!, forKey: kSecValueData as String)
            keyChainItem.setObject(IP, forKey:  kSecAttrServer as NSString)
            let status = SecItemAdd(keyChainItem, nil)
            if status == 0 {
                return true
            }
            return false
        }
    }
    
    class func UpdateIPItem(user_id:NSString,IP:NSString) -> Bool {
        let keyChainItem = NSMutableDictionary()
        keyChainItem.setObject(kSecClassInternetPassword as NSString, forKey: kSecClass as NSString)
        keyChainItem.setObject(user_id, forKey: kSecAttrAccount as NSString)
        
        if SecItemCopyMatching(keyChainItem,nil) == noErr{
            let updateDictionary = NSMutableDictionary()
            updateDictionary.setObject(IP, forKey:kSecAttrServer as String)
            _ = SecItemUpdate(keyChainItem,updateDictionary)
            return true
        }
        return false
    }
    
    class func UpdateKeyChainItem(user_id:NSString,user_password:NSString) -> Bool {
        let keyChainItem = NSMutableDictionary()
        keyChainItem.setObject(kSecClassInternetPassword as NSString, forKey: kSecClass as NSString)
        keyChainItem.setObject(user_id, forKey: kSecAttrAccount as NSString)
        
        if SecItemCopyMatching(keyChainItem,nil) == noErr{
            let updateDictionary = NSMutableDictionary()
            updateDictionary.setObject(user_password.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion:true)!, forKey:kSecValueData as String)
            _ = SecItemUpdate(keyChainItem,updateDictionary)
            return true
        }
        return false
    }
    
    class func GetKeyChainItem(user_id:NSString) -> NSString {
        let keyChainItem = NSMutableDictionary()
        keyChainItem.setObject(kSecClassInternetPassword as NSString, forKey: kSecClass as NSString)
        keyChainItem.setObject(user_id, forKey: kSecAttrAccount as NSString)
        
        keyChainItem.setObject(kCFBooleanTrue, forKey: kSecReturnData as String)
        keyChainItem.setObject(kCFBooleanTrue, forKey: kSecReturnAttributes as String)
        //let queryResult: Unmanaged<AnyObject>?
        
        var result: AnyObject?
        
        let status = withUnsafeMutablePointer(&result) {
            SecItemCopyMatching(keyChainItem,UnsafeMutablePointer($0))
        }
        if status == noErr {
            let opaque = (result as! Unmanaged<AnyObject>).toOpaque()
            let retrievedData = Unmanaged<NSArray>.fromOpaque(opaque).takeUnretainedValue()
            print(retrievedData)
            //let IP = retrievedData.objectForKey(kSecAttrServer) as! NSString
            //return IP
            
        }
//        SecItemCopyMatching(keyChainItem,(UnsafeMutablePointer)&queryResult)
//        let opaque = queryResult?.toOpaque()
//        var contentsOfKeychain: NSString?
//        if let op = opaque {
//            let retrievedData = Unmanaged<NSDictionary>.fromOpaque(op).takeUnretainedValue()
//            let passwordData = retrievedData.objectForKey(kSecValueData) as! NSData
//            return NSString(data: passwordData, encoding: NSUTF8StringEncoding)!
//        }
        return ""
    }
    
    static func GetIPItem(user_id:NSString) -> NSString {
        let keyChainItem = NSMutableDictionary()
        keyChainItem.setObject(kSecClassInternetPassword as NSString, forKey: kSecClass as NSString)
        keyChainItem.setObject(user_id, forKey: kSecAttrAccount as NSString)
        
        keyChainItem.setObject(kCFBooleanTrue, forKey: kSecReturnData as String)
        keyChainItem.setObject(kCFBooleanTrue, forKey: kSecReturnAttributes as String)
        //let queryResult: Unmanaged<AnyObject>?
        var result:AnyObject?
        let status = withUnsafeMutablePointer(&result) {
            SecItemCopyMatching(keyChainItem,UnsafeMutablePointer($0))
        }
        if status == noErr {
            let opaque = (result as! Unmanaged<AnyObject>).toOpaque()
            let retrievedData = Unmanaged<NSArray>.fromOpaque(opaque).takeUnretainedValue()
            print(retrievedData)
            //let IP = retrievedData.objectForKey(kSecAttrServer) as! NSString
            //return IP
        
        }
//        let opaque = queryResult?.toOpaque()
//        if let op = opaque {
//            let retrievedData = Unmanaged<NSDictionary>.fromOpaque(op).takeUnretainedValue()
//            let IP = retrievedData.objectForKey(kSecAttrServer) as! NSString
//            return IP
//        }
        return ""
    }

    static func deleteKeyChainItem(user_id:NSString) -> Bool {
        let keyChainItem = NSMutableDictionary()
        keyChainItem.setObject(kSecClassInternetPassword as NSString, forKey: kSecClass as NSString)
        keyChainItem.setObject(user_id, forKey: kSecAttrAccount as NSString)
        
        if SecItemCopyMatching(keyChainItem,nil) == noErr{
            let status = SecItemDelete(keyChainItem)
            if status == 0 {
                return true
            }
        }
        return false
    }

   
}
