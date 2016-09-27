//
//  SendButtonTableViewCell.swift
//  est
//
//  Created by warinporn khantithamaporn on 9/24/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

@objc protocol SendButtonTableViewCellDelegate {
    optional func sendButtonDidTap()
    optional func checkButtonDidTap()
}

class SendButtonTableViewCell: UITableViewCell {
    
    var sendButton = UIButton()
    var errorImageView = UIImageView()
    
    var delegate: SendButtonTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = UIColor.clearColor()
        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initCell() {
        self.sendButton.frame = CGRectMake(0.0, Est.calculatedHeightFromRatio(74.0), Est.calculatedWidthFromRatio(1242.0), Est.calculatedHeightFromRatio(210.0))
        self.sendButton.setImage(UIImage(named: "send_button"), forState: UIControlState.Normal)
        self.sendButton.setImage(UIImage(named: "send_button_disabled"), forState: .Disabled)
        
        self.sendButton.setTitleColor(UIColor.grayColor(), forState: .Disabled)
        
        self.sendButton.addTarget(self, action: #selector(SendButtonTableViewCell.send), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.addSubview(self.sendButton)
        
        self.errorImageView.frame = CGRectMake(0.0, -1.0 * Est.calculatedHeightFromRatio(8.0), Est.calculatedWidthFromRatio(518.0), Est.calculatedHeightFromRatio(81.0))
        self.errorImageView.image = UIImage(named: "error_code")
        self.errorImageView.hidden = true
        
        self.contentView.addSubview(self.errorImageView)
    }
    
    func initCell(checkWinner: Bool) {
        self.sendButton.frame = CGRectMake(0.0, Est.calculatedHeightFromRatio(46.0), Est.calculatedWidthFromRatio(1242.0), Est.calculatedHeightFromRatio(210.0))
        self.sendButton.setImage(UIImage(named: "check_winner_button"), forState: .Normal)
        self.sendButton.setImage(UIImage(named: "check_winner_button_disabled"), forState: .Disabled)
        
        self.sendButton.addTarget(self, action: #selector(SendButtonTableViewCell.check), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.addSubview(self.sendButton)
    }
    
    func send() {
        self.delegate?.sendButtonDidTap!()
    }
    
    func check() {
        print("checkButtonDidTap")
        self.delegate?.checkButtonDidTap!()
    }
    
}
