//
//  Extension.swift
//  ShareAndNav
//
//  Created by xubupt218 on 15/12/3.
//  Copyright © 2015年 徐成. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func sizeWithMaxSize(mSize:CGSize,font:UIFont) -> CGSize {
        let str = NSString(string: self)
        let rect = str.boundingRectWithSize(mSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil)
        return rect.size
    }
}

extension UIImage {
    func resize(size:CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        self.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UILabel {
    func widthFitText() -> CGFloat {
        guard self.text != nil else {return 0}
        return self.font.pointSize * CGFloat(NSString(string: self.text!).length)
    }
    
    func cornerBorder(cornerRadius:CGFloat,font:UIFont) {
        self.layer.borderColor = AlStyle.color.gray.CGColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 2
        self.font = font
        self.textAlignment = NSTextAlignment.Center
        self.layer.backgroundColor = AlStyle.color.white.CGColor
    }
}

extension String {
    func toDate() -> NSDate? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.dateFromString(self)
    }
    
    func dateStringSinceDate(dateString:String) -> String? {
        let date = self.toDate()?.timeIntervalSinceDate(dateString.toDate()!)
        guard date != nil else {return nil}
        var timeInterval = -date!
        var day = 0
        while timeInterval > 86400 {
            timeInterval -= 86400
            day += 1
        }
        let zeroString = "00:00:00"
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let newDate = NSDate(timeInterval: timeInterval, sinceDate: formatter.dateFromString(zeroString)!)
        var s = formatter.stringFromDate(newDate)
        print(s)
        print(s.substringToIndex(s.startIndex.advancedBy(2)))
        var hh = NSString(string: s.substringToIndex(s.startIndex.advancedBy(2))).intValue
        if day > 0 {
            day *= 24
        }
        hh += day
        s.replaceRange(s.startIndex ..< s.startIndex.advancedBy(2), with: "\(hh)")
        return s
    }
}

extension NSDate {
    func toString() -> NSString {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.stringFromDate(self)
    }
    
    class func ZeroDate() -> NSDate? {
        let zeroString = "00:00:00"
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.dateFromString(zeroString)
    }
}


//MARK:--自定义运算符
//除法向上取整 左结合，优先级150，与 * 、/ 优先级相同
infix operator /+ {associativity left precedence 150}
func /+ (left:Int,right:Int) -> Int {
    if left % right != 0 {
        return left / right + 1
    }
    return left / right
}

//数组和运算
func + <T : _IntegerArithmeticType> (left: [T], right: [T]) -> [T] { // 1
    assert(left.count == right.count, "vector of same length only")  // 2
    var sum = [T]() // 3
    for (key, v) in left.enumerate() {
        sum.append(v + right[key]) // 4
    }
    return sum
}