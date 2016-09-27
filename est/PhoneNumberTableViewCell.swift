//
//  PhoneNumberTableViewCell.swift
//  est
//
//  Created by warinporn khantithamaporn on 9/23/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

class PhoneNumberTableViewCell: UITableViewCell {
    
    var backgroundImageView = UIImageView()
    var textField = UITextField()
    
    var checkMarkImageView = UIImageView()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clearColor()
        self.clipsToBounds = true
        self.selectionStyle = .None
        self.textField.keyboardType = .NumberPad
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func initCell() {
        self.backgroundImageView.frame = CGRectMake(0.0, 0.0, Est.calculatedWidthFromRatio(1242.0), Est.calculatedHeightFromRatio(1225.0))
        self.backgroundImageView.image = UIImage(named: "phonenumber_full_cell")
        self.contentView.addSubview(self.backgroundImageView)
        
        self.checkMarkImageView.frame = CGRectMake(Est.calculatedWidthFromRatio(1060.0), Est.calculatedHeightFromRatio(1118.0), Est.calculatedWidthFromRatio(47.0), Est.calculatedHeightFromRatio(35.0))
        self.checkMarkImageView.image = UIImage(named: "checkmark")
        
        self.contentView.addSubview(self.checkMarkImageView)
        
        self.textField.frame = Est.calculatedRectFromRatio(211.0, y: 1084.0, w: 820, h: 100.0)
        self.textField.placeholder = "กรอกเบอร์โทรศัพท์มือถือ"
        self.textField.textAlignment = .Center
        self.textField.font = UIFont(name: Est.DBHELVETHAICA_X_REGULAR, size: Est.calculatedHeightFromRatio(78.0))
        
        self.contentView.addSubview(self.textField)
    }
    
    func initCell(checkWinner: Bool) {
        self.backgroundImageView.frame = CGRectMake(0.0, 0.0, Est.calculatedWidthFromRatio(1242.0), Est.calculatedHeightFromRatio(1144.0))
        self.backgroundImageView.image = UIImage(named: "check_winner_phone_cell")
        self.contentView.addSubview(self.backgroundImageView)
        
        self.checkMarkImageView.frame = CGRectMake(Est.calculatedWidthFromRatio(1060.0), Est.calculatedHeightFromRatio(1037.0), Est.calculatedWidthFromRatio(47.0), Est.calculatedHeightFromRatio(35.0))
        self.checkMarkImageView.image = UIImage(named: "checkmark")
        
        self.contentView.addSubview(self.checkMarkImageView)
        
        self.textField.frame = Est.calculatedRectFromRatio(211.0, y: 1003.0, w: 820, h: 100.0)
        self.textField.placeholder = "กรอกเบอร์โทรศัพท์มือถือ"
        self.textField.textAlignment = .Center
        self.textField.font = UIFont(name: Est.DBHELVETHAICA_X_REGULAR, size: Est.calculatedHeightFromRatio(78.0))
        
        self.contentView.addSubview(self.textField)
    }
    
}
