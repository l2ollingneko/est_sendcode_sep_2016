//
//  EstPopupAlertView.swift
//  est
//
//  Created by warinporn khantithamaporn on 9/28/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

class EstPopupAlertView: UIView {
    
    let size = CGSizeMake(Est.calculatedWidthFromRatio(850.0), Est.calculatedHeightFromRatio(200.0))
    
    var messageLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: CGRectMake((Est.rWidth - size.width) / 2.0, (Est.rHeight - size.height) / 2.0, size.width, size.height))
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.85)
        
        self.layer.cornerRadius = 4.0
        self.clipsToBounds = true
        
        self.messageLabel.frame = CGRectMake(0.0, 0.0, size.width, size.height)
        self.messageLabel.font = UIFont(name: Est.DBHELVETHAICA_X_MEDIUM, size: Est.calculatedHeightFromRatio(70.0))
        self.messageLabel.textColor = UIColor.whiteColor()
        self.messageLabel.textAlignment = .Center
        
        self.addSubview(self.messageLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initMessage(message: String) {
        self.messageLabel.text = message
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
