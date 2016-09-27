//
//  MenuTableViewCell.swift
//  est
//
//  Created by warinporn khantithamaporn on 9/25/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    var menuImageView = UIImageView()

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
        self.menuImageView.frame = CGRectMake(0.0, (self.frame.size.height - Est.calculatedHeightFromRatio(140.0)) / 2.0, Est.calculatedWidthFromRatio(1242.0), Est.calculatedHeightFromRatio(140.0))
        self.menuImageView.image = UIImage(named: "sendcode_menu_off")
        self.addSubview(self.menuImageView)
    }
    
    func initCell(name: String) {
        self.menuImageView.frame = CGRectMake(0.0, (self.frame.size.height - Est.calculatedHeightFromRatio(140.0)) / 2.0, Est.calculatedWidthFromRatio(1242.0), Est.calculatedHeightFromRatio(140.0))
        self.menuImageView.image = UIImage(named: "\(name)_menu_off")
        self.addSubview(self.menuImageView)
    }
    
    func initCell(name: String, on: Bool) {
        self.menuImageView.frame = CGRectMake(0.0, (self.frame.size.height - Est.calculatedHeightFromRatio(140.0)) / 2.0, Est.calculatedWidthFromRatio(1242.0), Est.calculatedHeightFromRatio(140.0))
        self.menuImageView.image = UIImage(named: "\(name)_menu_on")
        self.addSubview(self.menuImageView)
    }
    
}
