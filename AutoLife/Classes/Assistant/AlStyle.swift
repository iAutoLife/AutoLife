//
//  AlStyle.swift
//  AutoLife
//
//  Created by xubupt218 on 16/4/22.
//  Copyright © 2016年 徐成. All rights reserved.
//
import Foundation
import UIKit

internal struct AlStyle {
    
    //10.104.5.172:8080
    internal static let uHeader = "http://139.129.110.224/CarManageSystem/"       //139.129.110.224
    internal static let cornerRadius:CGFloat = 5
    internal static let size = UIScreen.mainScreen().bounds.size
    internal static var scale = UIScreen.mainScreen().scale
    internal static let XuWidth = UIScreen.mainScreen().bounds.width
    internal static let XuHeight =  UIScreen.mainScreen().bounds.height
    internal static var cellHeight:CGFloat = {
        var once:dispatch_once_t = 0
        var height:CGFloat!
        dispatch_once(&once, { () -> Void in
            print("dispatch_once cellHeight")
            height = AlStyle.algebraConvert(44)
        })
        return height
        }()
    internal struct textSize{
        internal static var smallest:CGFloat{
            return AlStyle.algebraConvert(10)
        }
        internal static var small:CGFloat{
            return AlStyle.algebraConvert(12)
        }
        internal static var normal:CGFloat{
            return AlStyle.algebraConvert(14)
        }
        internal static var big:CGFloat{
            return AlStyle.algebraConvert(16)
        }
        internal static var nav:CGFloat{
            return AlStyle.algebraConvert(18)
        }
    }
    
    internal struct font {
        
        internal static var smallest:UIFont {
            return UIFont.systemFontOfSize(AlStyle.algebraConvert(10))
        }
        
        internal static var small:UIFont {
            return UIFont.systemFontOfSize(AlStyle.algebraConvert(12))
        }
        
        internal static var normal:UIFont {
            return UIFont.systemFontOfSize(AlStyle.algebraConvert(14))
        }
        
        internal static var big:UIFont {
            return UIFont.systemFontOfSize(AlStyle.algebraConvert(16))
        }
        
        internal static var nav:UIFont {
            return UIFont.systemFontOfSize(AlStyle.algebraConvert(18))
        }
    }
    
    internal static func algebraConvert (id:CGFloat) -> CGFloat {
        #if IPHONE6 || IPHONE6S
            return id
        #else
            return id * CGFloat(size.width / 375.0)
        #endif
    }
    
    struct color {
        internal static var blue:UIColor {
            return UIColor(red: 0, green: 132/255, blue: 1, alpha: 1)
        }
        
        internal static var blue_light:UIColor {
            return UIColor(red: 127/255, green: 193/255, blue: 1, alpha: 1)
        }
        
        internal static var blue_dark:UIColor {
            return UIColor(red: 0.12, green: 0.12, blue: 0.3, alpha: 1)
        }
        
        internal static var white:UIColor {
            return UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
        }
        
        internal static var gray:UIColor {
            return UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        }
        
        internal static var gray_light:UIColor {
            return UIColor(red: 230/255, green: 230/255, blue: 235/255, alpha: 1)
        }
        
        internal static var black:UIColor {
            return UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
        }
        
        internal static var green_dark:UIColor {
            return UIColor(red: 51/255, green: 113/255, blue: 65/255, alpha: 1)
        }
    }
}