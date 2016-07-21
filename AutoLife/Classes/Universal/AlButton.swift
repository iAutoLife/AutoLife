//
//  AlButton.swift
//  iAutoLife
//
//  Created by XuBupt on 16/4/26.
//  Copyright © 2016年 xubupt218. All rights reserved.
//

import UIKit

enum AlButtonStyleVertical {
    case imageAboveTitle,imageBelowTitle
}

class AlButton: UIButton {
    
    var style = AlButtonStyleVertical.imageAboveTitle
    var gapForIT:CGFloat = 0

    private func imageAboveTitle() {   //图上文下
        let imageWidth = imageView!.frame.width
        let imageHeight = imageView!.frame.height
        let titleWidth = titleLabel!.frame.width
        let titleHeight = titleLabel!.frame.height
        self.imageEdgeInsets = UIEdgeInsetsMake(-imageHeight / 2, titleWidth / 2, imageHeight / 2, -titleWidth / 2)
        self.titleEdgeInsets = UIEdgeInsetsMake(titleHeight / 2 + gapForIT, -imageWidth / 2, -(titleHeight / 2 + gapForIT), imageWidth / 2)
    }
    
    private func imageBelowTitle() {
        let imageWidth = imageView!.frame.width
        let imageHeight = imageView!.frame.height
        let titleWidth = titleLabel!.frame.width
        let titleHeight = titleLabel!.frame.height
        self.imageEdgeInsets = UIEdgeInsetsMake(imageHeight / 2, titleWidth / 2, -imageHeight / 2, -titleWidth / 2)
        self.titleEdgeInsets = UIEdgeInsetsMake(-titleHeight / 2, -imageWidth / 2, titleHeight / 2, imageWidth / 2)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        switch style {
        case .imageAboveTitle:
            self.imageAboveTitle()
            
        case .imageBelowTitle:
            self.imageBelowTitle()
        }
    }

}
