//
//  CodeTableViewCell.swift
//  est
//
//  Created by warinporn khantithamaporn on 9/24/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit
import THLabel

class CodeTableViewCell: UITableViewCell {

    var backgroundImageView = UIImageView()
    var indexLabel = THLabel()
    var textField = UITextField()
    
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
        self.backgroundImageView.frame = CGRectMake(0.0, 0.0, Est.calculatedWidthFromRatio(1242.0), Est.calculatedHeightFromRatio(160.0))
        self.backgroundImageView.image = UIImage(named: "code_cell")
        self.contentView.addSubview(self.backgroundImageView)
    }
    
    func initCell(type: Int) {
        self.backgroundImageView.frame = CGRectMake(0.0, 0.0, Est.calculatedWidthFromRatio(1242.0), Est.calculatedHeightFromRatio(160.0))
        if (type == 0) {
            self.backgroundImageView.image = UIImage(named: "code_cell")
            
            let placeholder = NSAttributedString(string: "กรอกรหัส 11 ตัวเลข", attributes: [NSForegroundColorAttributeName : UIColor.grayColor()])
            self.textField.attributedPlaceholder = placeholder
            
            self.textField.textColor = UIColor.blackColor()
            self.textField.userInteractionEnabled = true
        } else if (type == 1) {
            self.backgroundImageView.image = UIImage(named: "dim_code_cell")
            
            let placeholder = NSAttributedString(string: "กรอกรหัส 11 ตัวเลข", attributes: [NSForegroundColorAttributeName : UIColor.grayColor()])
            self.textField.attributedPlaceholder = placeholder
            
            self.textField.textColor = UIColor.blackColor()
            self.textField.userInteractionEnabled = false
        } else {
            self.backgroundImageView.image = UIImage(named: "error_code_cell")
    
            let placeholder = NSAttributedString(string: "กรอกรหัส 11 ตัวเลข", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
            self.textField.attributedPlaceholder = placeholder
            self.textField.textColor = UIColor.whiteColor()
            
            self.textField.userInteractionEnabled = true
        }
        self.contentView.addSubview(self.backgroundImageView)
    }
    
    func initCell(index: Int, type: Int) {
        self.initCell(type)
        
        self.indexLabel.frame = CGRectMake(Est.calculatedWidthFromRatio(106.0), Est.calculatedHeightFromRatio(48.0), Est.calculatedWidthFromRatio(60.0), Est.calculatedHeightFromRatio(60.0))
        self.indexLabel.font = UIFont(name: Est.DBHELVETHAICA_X_MEDIUM, size: Est.calculatedHeightFromRatio(70.0))
        self.indexLabel.textColor = UIColor.whiteColor()
        self.indexLabel.textAlignment = .Center
        
        self.indexLabel.text = "\(index)"
        self.contentView.addSubview(self.indexLabel)
        
        self.textField.frame = Est.calculatedRectFromRatio(211.0, y: 33.0, w: 820, h: 100.0)
        self.textField.placeholder = "กรอกรหัส 11 ตัวเลข"
        self.textField.textAlignment = .Center
        self.textField.font = UIFont(name: Est.DBHELVETHAICA_X_REGULAR, size: Est.calculatedHeightFromRatio(78.0))
    
        self.contentView.addSubview(self.textField)
    }
    
}
