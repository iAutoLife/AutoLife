//
//  XuRegularExpression.swift
//  ShareAndNav
//
//  Created by 徐成 on 15/11/4.
//  Copyright © 2015年 徐成. All rights reserved.
//

import UIKit

enum XuRegularType {
    //纯数字，手机号或带区号的座机，邮箱，身份证，银行卡号，百分比，小数点
    case digital,tel,phone,telephone,email,identifyCard,bank,percent,decimal
}

//正则表达式  自写
/*正则表达式语法说明
    1. ^开头，$结尾
    2. x*,零次或者多次；+一次或者多次；？零次或者一次；
        {n},其前一个字符出现n次
        {n,},至少n次； {n,m}，其中n<m，至少n，最多m次
*/

class XuRegularExpression: NSObject {
    
    class func isVaild(value:String?,fortype type:XuRegularType) -> Bool {
        guard value != "" else {return false}
        var predicateString:String = ""
        switch type {
        case .digital:
            predicateString = "^[0-9]*$"
        case .tel:
            predicateString = "((^(\\d{3}-)?\\d{8}|(^\\d{4}-)?\\d{7})(-\\d{1,4})?)|^1[34578]\\d{9}"
        case .phone:
            predicateString = "^1[34578]\\d{9}"
        case .telephone:
            predicateString = "((^(\\d{3}-)?\\d{8}|(^\\d{4}-)?\\d{7})(-\\d{1,4})?)"
        case .email:
            predicateString = "[A-Z0-9a-z._%+-]+@([A-Za-z0-9.-]+.)+(com|cn)+"
        case .identifyCard:
            predicateString = "^[1-9]\\d{5}(19|20)\\d{2}(0[1-9]|1[0-2])([0-2]\\d|3[0-1])\\d{4}"
        case .bank:
            predicateString = "^\\d{19}$"
        case .percent:
            predicateString = "^\\d*(.\\d+)*%$"
        case .decimal:
            predicateString = "^0\\.\\d+$"
        }
        let predicate = NSPredicate(format: "SELF MATCHES %@", predicateString)
        return predicate.evaluateWithObject(value)
    }
}
