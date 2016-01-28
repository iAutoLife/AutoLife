//
//  XuGCD.swift
//  AutoLife
//
//  Created by xubupt218 on 16/1/28.
//  Copyright © 2016年 徐成. All rights reserved.
//

import UIKit

class XuGCD: NSObject {
    
    class func after(mSec:UInt64 ,closure:()->Void) {
        let gcdAfter = dispatch_time(DISPATCH_TIME_NOW, Int64(mSec * USEC_PER_SEC))
        dispatch_after(gcdAfter, dispatch_get_main_queue()) { () -> Void in
            closure()
        }
    }
}
