//
//  XuAnnotationView.swift
//  AutoLife
//
//  Created by 徐成 on 16/1/15.
//  Copyright © 2016年 徐成. All rights reserved.
//

import UIKit

class XuAnnotationView: MAAnnotationView {
    
    var calloutView:XuCustomPointView?
    var label:UILabel?
    
    override init!(annotation: MAAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }

    func setAnnotationIndex(indexString:String) {
        label = UILabel(frame: CGRectMake(0,0,self.frame.width,self.frame.height))
        label?.textAlignment = NSTextAlignment.Center
        label?.font = AlStyle.font.normal
        label?.textColor = UIColor.whiteColor()
        label?.text = indexString
        label?.transform = CGAffineTransformMakeTranslation(0, -self.frame.height / 6)
        self.addSubview(label!)
        
    }
    
    func setAnnotationImage(image:UIImage?) {
        guard image != nil else {return}
        let xi = image?.resizableImageWithCapInsets(UIEdgeInsetsMake(image!.size.width / 2 - 0.5, image!.size.height / 2 - 0.5, image!.size.width / 2 - 0.5, image!.size.height / 2 - 0.5))
        self.image = xi
        print(self.image.size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    override func setSelected(selected: Bool, animated: Bool) {
        let imageName = (selected ? "location_blue" : "location_red")
        self.image = UIImage(named: imageName)
        guard self.selected != selected else {return}
        guard selected else {return}
    }
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        var isInside = super.pointInside(point, withEvent: event)
        if !isInside && self.selected {
            isInside = false
        }
        
        return isInside
    }
}
