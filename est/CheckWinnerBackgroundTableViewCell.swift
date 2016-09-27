//
//  CheckWinnerBackgroundTableViewCell.swift
//  est
//
//  Created by warinporn khantithamaporn on 9/26/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

class CheckWinnerBackgroundTableViewCell: UITableViewCell {
    
    var announceImageView = UIImageView()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initCell() {
        self.backgroundView = UIImageView(frame: CGRectMake(0.0, 0.0, Est.calculatedWidthFromRatio(1242.0), Est.calculatedHeightFromRatio(3568.0)))
        (self.backgroundView as! UIImageView).image = UIImage(named: "check_winner_bg")
        (self.backgroundView as! UIImageView).contentMode = .ScaleToFill
    }
    
    func initCell(announce: Int) {
        self.backgroundView = UIImageView(frame: CGRectMake(0.0, 0.0, Est.calculatedWidthFromRatio(1242.0), Est.calculatedHeightFromRatio(3568.0)))
        (self.backgroundView as! UIImageView).image = UIImage(named: "check_winner_bg")
        (self.backgroundView as! UIImageView).contentMode = .ScaleToFill
        
        // x: 0, y: 1558
        self.announceImageView = UIImageView(frame: CGRectMake(0.0, Est.calculatedHeightFromRatio(1558.0), Est.calculatedWidthFromRatio(1242.0), Est.calculatedHeightFromRatio(1741.0)))
        self.announceImageView.image = UIImage(named: "announce_\(announce)")
        self.announceImageView.contentMode = .ScaleToFill
        
        self.contentView.addSubview(self.announceImageView)
    }
    
}
