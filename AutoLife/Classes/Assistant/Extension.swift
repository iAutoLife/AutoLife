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
