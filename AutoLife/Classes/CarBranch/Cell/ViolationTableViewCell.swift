//
//  ViolationTableViewCell.swift
//  AutoLife
//
//  Created by 徐成 on 15/11/6.
//  Copyright © 2015年 徐成. All rights reserved.
//
import UIKit

class ViolationTableViewCell: UITableViewCell {
    
    private var luLabel:UILabel!
    private var ldLabel:UILabel!
    private var ruLabel:UILabel!
    private var rdLabel:UILabel!
    private var locateBtn:UIButton!
    
    var locationClosure : (() -> Void)?
    var xviolation:NSDictionary? {
        didSet{
            guard xviolation != nil else {return}
            luLabel.text = "\(xviolation!["date"] as! String)"
            ruLabel.text = "\(xviolation!["reason"] as! String) 扣\(xviolation!["point"] as! String)"
            ldLabel.text = "\(xviolation!["address"] as! String)"
            rdLabel.text = "罚款" + (xviolation!["forfeit"] as! String)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    init(reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        self.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        self.initBaseView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initBaseView() {
        let xShift:CGFloat = (self.accessoryType == UITableViewCellAccessoryType.DisclosureIndicator ? 10 : 0)
        luLabel = UILabel(frame: CGRectMake(30,5,200,15))
        luLabel.font = UIFont.systemFontOfSize(XuTextSizeSmall)
        self.contentView.addSubview(luLabel)
        
        ldLabel = UILabel(frame: CGRectMake(30,25,220,15))
        ldLabel.font = UIFont.systemFontOfSize(XuTextSizeSmall)
        self.contentView.addSubview(ldLabel)
        
        let rs = CGRectGetMaxX(luLabel.frame)
        ruLabel = UILabel(frame: CGRectMake(rs + 10 - xShift,5,XuWidth - rs - 25,15))
        ruLabel.font = UIFont.systemFontOfSize(XuTextSizeSmall)
        ruLabel.textAlignment = NSTextAlignment.Right
        self.contentView.addSubview(ruLabel)
        
        rdLabel = UILabel(frame: CGRectMake(rs + 10 - xShift,25,XuWidth - rs - 25,15))
        rdLabel.font = UIFont.systemFontOfSize(XuTextSizeSmall)
        rdLabel.textAlignment = NSTextAlignment.Right
        self.contentView.addSubview(rdLabel)
        
        locateBtn = UIButton(type: UIButtonType.System)
        locateBtn.frame = CGRectMake(10, 20, 20, 20 * imageOfLocation.size.height / imageOfLocation.size.width)
        locateBtn.setImage(imageOfLocation, forState: UIControlState.Normal)
        locateBtn.addTarget(self, action: "locationAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.contentView.addSubview(locateBtn)
    }
    
    func locationAction(sender:UIButton) {
        self.locationClosure?()
    }
}


