//
//  AlTextField.swift
//  iAutoLife
//
//  Created by XuBupt on 16/4/26.
//  Copyright © 2016年 xubupt218. All rights reserved.
//

import UIKit

@IBDesignable class AlTextField: UITextField {
    
    private let lineLayer = CALayer()

    @IBInspectable dynamic internal var lineColor : UIColor? {
        didSet{
            setLineLayer()
        }
    }
    
    override func drawRect(rect: CGRect) {
        layer.addSublayer(lineLayer)
        setLineLayer()
    }
    
    private func setLineLayer() {
        lineLayer.frame = CGRectMake(0, frame.height - 5, frame.width, 0.5)
        lineLayer.backgroundColor = lineColor?.CGColor
    }

}
