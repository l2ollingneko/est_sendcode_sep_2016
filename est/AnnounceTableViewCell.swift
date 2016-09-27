//
//  AnnounceTableViewCell.swift
//  est
//
//  Created by warinporn khantithamaporn on 9/26/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit
import THLabel
import SwiftHEXColors

class AnnounceTableViewCell: UITableViewCell {
    
    var dateLabel = THLabel()
    
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
        self.dateLabel.frame = CGRectMake(Est.calculatedWidthFromRatio(276.0), Est.calculatedHeightFromRatio(72.0), Est.calculatedWidthFromRatio(510.0), Est.calculatedHeightFromRatio(90.0))
        self.dateLabel.font = UIFont(name: Est.DBHELVETHAICA_X_BOLD_ITALIC, size: Est.calculatedHeightFromRatio(74.0))
        self.dateLabel.text = "3 ตุลาคม 2559"
        
        self.dateLabel.textColor = Est.EST_YELLOW
        
        self.dateLabel.strokeColor = UIColor.blackColor()
        self.dateLabel.strokeSize = Est.calculatedWidthFromRatio(10.0)
        
        self.dateLabel.transform = CGAffineTransformMakeRotation(CGFloat(M_PI) * 1.969)
        
        self.contentView.addSubview(self.dateLabel)
    }
    
    func initCell(date: String, type: Int) {
        self.dateLabel.frame = CGRectMake(Est.calculatedWidthFromRatio(276.0), Est.calculatedHeightFromRatio(72.0), Est.calculatedWidthFromRatio(510.0), Est.calculatedHeightFromRatio(90.0))
        self.dateLabel.font = UIFont(name: Est.DBHELVETHAICA_X_BOLD_ITALIC, size: Est.calculatedHeightFromRatio(74.0))
        self.dateLabel.text = "3 ตุลาคม 2559"
        
        self.dateLabel.strokeSize = Est.calculatedWidthFromRatio(10.0)
        
        if (type == 0) {
            self.dateLabel.textColor = UIColor.blackColor()
            self.dateLabel.strokeColor = Est.EST_YELLOW
        } else {
            self.dateLabel.textColor = Est.EST_YELLOW
            self.dateLabel.strokeColor = UIColor.blackColor()
        }
        
        self.dateLabel.transform = CGAffineTransformMakeRotation(CGFloat(M_PI) * 1.969)
        
        self.contentView.addSubview(self.dateLabel)
    }
    
}
