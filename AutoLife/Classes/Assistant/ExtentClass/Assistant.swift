//
//  Assistant.swift
//  AutoLife
//
//  Created by xubupt218 on 16/1/18.
//  Copyright © 2016年 徐成. All rights reserved.
//

import UIKit

class Assistant: NSObject {
    
    class func alertHint(title:String?,message:String?)->UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "好的", style: UIAlertActionStyle.Cancel, handler: nil))
        return alert
    }
}
