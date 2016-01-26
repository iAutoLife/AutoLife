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
    func sizeWithMaxSize(mSize:CGSize,fontSize:CGFloat) -> CGSize {
        let str = NSString(string: self)
        return str.boundingRectWithSize(mSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(fontSize)], context: nil).size
    }
}

extension UIImage {
    func resize(size:CGSize)->UIImage {
        UIGraphicsBeginImageContext(size)
        self.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension MBProgressHUD {
    
}


//MARK:--自定义运算符
infix operator %+ {associativity left precedence 150}
func %+ (left:Int,right:Int) -> Int {
    if left % right != 0 {
        return left / right + 1
    }
    return left / right
}

func + (left: [Int], right: [Int]) -> [Int] { // 1
    var sum = [Int]() // 2
    assert(left.count == right.count, "vector of same length only")  // 3
    for (key, v) in left.enumerate() {
        sum.append(v + right[key]) // 4
    }
    return sum
}