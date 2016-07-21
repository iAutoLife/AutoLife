//
//  FeatureView.swift
//  iAutoLife
//
//  Created by XuBupt on 16/4/26.
//  Copyright © 2016年 xubupt218. All rights reserved.
//

import UIKit

enum FeatureViewStyle {
    case normal,complicated
}

class FeatureView: UIView {
    
    var style = FeatureViewStyle.normal
    var subColor:UIColor? {
        didSet{
            subLabel?.textColor = subColor
        }
    }
    
    var clicked:(() -> Void)?
    
    private var button = UIButton.init(type: .Custom)
    private var mainLabel = UILabel()
    private var subLabel:UILabel?
    private var branchLabel:UILabel?
    private var attachedLabel:UILabel?
    private let gap = AlStyle.algebraConvert(6)
    
    init() {
        super.init(frame: CGRectZero)
        self.addSubview(mainLabel)
        mainLabel.textColor = AlStyle.color.blue_dark
        mainLabel.font = AlStyle.font.normal
        mainLabel.text = "消息"
        self.layer.cornerRadius = AlStyle.cornerRadius
        self.layer.backgroundColor = AlStyle.color.white.CGColor
        self.addSubview(button)
        button.addTarget(self, action: #selector(clicked(_:)), forControlEvents: .TouchUpInside)
        switch style {
        case .normal:
            self.setSubLabel()
        default:
            break
        }
    }
    
    func clicked(sender:AnyObject) {
        self.clicked?()
    }
//    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        print("touchesBegan")
//        self.layer.backgroundColor = AlStyle.color.gray_light.CGColor
//        
//    }
//    
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        print("touchesEnded")
//        self.layer.backgroundColor = AlStyle.color.white.CGColor
//    }
    
    func normal(title title:String,andText text:String) {
        self.mainLabel.text = title
        self.subLabel?.text = text
    }
    
    func normalAttributed(title title:NSAttributedString, andText text:String) {
        self.mainLabel.attributedText = title
        self.subLabel?.text = text
    }
    
    override func layoutSubviews() {
        button.snp_makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(self)
        }
        mainLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.topAnchor).offset(gap)
            make.left.equalTo(self.leftAnchor).offset(gap)
        }
        
        subLabel?.snp_makeConstraints(closure: { (make) in
            make.right.equalTo(self.rightAnchor).offset(-self.frame.width * 0.1)
            make.bottom.equalTo(self.bottomAnchor).offset(-gap)
        })
    }
    
    //MARK: --subview
    func setSubLabel() {
        subLabel = UILabel.init()
        self.addSubview(subLabel!)
        subLabel!.textColor = AlStyle.color.green_dark
        subLabel!.font = AlStyle.font.smallest
        subLabel!.text = "请注册/登录"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
