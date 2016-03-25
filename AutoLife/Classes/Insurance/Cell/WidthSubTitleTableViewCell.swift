//
//  WidthSubTitleTableViewCell.swift
//  AutoLife
//
//  Created by xubupt218 on 16/3/23.
//  Copyright © 2016年 徐成. All rights reserved.
//

import UIKit

class WidthSubTitleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTitleLabel: UILabel!
    
    func setTitle(title:String,detailTitle:String) {
        self.titleLabel.text = title
        self.detailTitleLabel.text = detailTitle
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
