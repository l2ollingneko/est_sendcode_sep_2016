//
//  NoticeTableViewCell.swift
//  est
//
//  Created by warinporn khantithamaporn on 9/24/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

class NoticeTableViewCell: UITableViewCell {
    
    var noticeButton = UIButton()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = UIColor.clearColor()
        self.clipsToBounds = true
        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initCell() {
        self.noticeButton.frame = CGRectMake(0.0, Est.calculatedHeightFromRatio(0.0), Est.calculatedWidthFromRatio(1242.0), Est.calculatedHeightFromRatio(81.0))
        self.noticeButton.setImage(UIImage(named: "notice_cell"), forState: UIControlState.Normal)
        self.addSubview(self.noticeButton)
    }
    
}
