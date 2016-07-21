//
//  WayOfPayTableViewCell.swift
//  AutoLife
//
//  Created by XuBupt on 16/7/10.
//  Copyright © 2016年 徐成. All rights reserved.
//

import UIKit

class WayOfPayTableViewCell: UITableViewCell {
    
    private var leftImageView : UIImageView?
    private let leftLabel = UILabel.init()
    private var leftSubLabel:UILabel?
    private let rightCheck = UIButton.init(type: .Custom)

    init(reuseIdentifier:String) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        leftLabel.font = AlStyle.font.normal
        contentView.addSubview(leftLabel)
        rightCheck.setImage(UIImage(named: "check_no"), forState: .Normal)
        rightCheck.setImage(UIImage(named: "check_yes"), forState: .Selected)
        contentView.addSubview(rightCheck)
    }
    
    func setCheck(selected:Bool) {
        rightCheck.selected = selected
    }
    
    func setLeftImage(image:UIImage?) {
        leftImageView = UIImageView.init(image: image!)
        leftImageView?.contentMode = UIViewContentMode.ScaleAspectFit
        contentView.addSubview(leftImageView!)
    }
    
    func setLeftText(text:String) {
        leftLabel.text = text
    }
    
    func setLeftSubText(text:String) {
        leftSubLabel = UILabel.init()
        leftSubLabel?.text = text
        leftSubLabel?.font = AlStyle.font.small
        leftSubLabel?.textColor = AlStyle.color.gray
        contentView.addSubview(leftSubLabel!)
    }
    
    override func layoutSubviews() {
        leftImageView?.snp_makeConstraints(closure: { (make) in
            make.left.equalTo(contentView).offset(15)
            make.centerY.equalTo(self.contentView)
            make.height.width.equalTo(30)
        })
        
        leftLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            if leftImageView == nil {
                make.left.equalTo(contentView).offset(15)
            }else {
                make.left.equalTo(leftImageView!.snp_right).offset(10)
            }
        }
        leftSubLabel?.snp_makeConstraints(closure: { (make) in
            make.left.equalTo(leftLabel.snp_right).offset(10)
            make.centerY.equalTo(leftLabel)
        })
        rightCheck.snp_makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-20)
            make.centerY.equalTo(leftLabel)
            make.width.height.equalTo(20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
