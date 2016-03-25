//
//  SunTableViewCell.swift
//  AutoLife
//
//  Created by xubupt218 on 16/3/21.
//  Copyright © 2016年 徐成. All rights reserved.
//

import UIKit

class SunTableViewCell: UITableViewCell {
    
    @IBOutlet weak var acLabel: UILabel!
    @IBOutlet weak var telBtn: UIButton!
    @IBOutlet weak var i1Label: UILabel!
    @IBOutlet weak var i1DateLabel: UILabel!
    @IBOutlet weak var i1MLabel: UILabel!
    @IBOutlet weak var i2Label: UILabel!
    @IBOutlet weak var i2MLabel: UILabel!
    @IBOutlet weak var i3Label: UILabel!
    @IBOutlet weak var i3DateLabel: UILabel!
    @IBOutlet weak var i3MLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData() {
        acLabel.text = "1021**459  王麻子  阳光保险"
        i1Label.text = "交强险"
        i1DateLabel.text = "2016-2-15 00:00 - 2017-3-14 23:59"
        i1MLabel.text = "¥855.00"
        i2Label.text = "车船使用税"
        i2MLabel.text = "¥400.00"
        i3Label.text = "商业险"
        i3DateLabel.text = "8项 2016-2-15 00:00 - 2017-3-14 23:59"
        i3MLabel.text = "¥2568.00"
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
