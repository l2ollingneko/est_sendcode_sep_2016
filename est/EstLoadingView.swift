//
//  EstLoadingView.swift
//  est
//
//  Created by warinporn khantithamaporn on 9/28/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

class EstLoadingView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: CGRectMake(0.0, 0.0, Est.calculatedWidthFromRatio(1242.0), Est.calculatedHeightFromRatio(2208.0)))
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        indicator.startAnimating()
        indicator.center = self.center
        
        self.addSubview(indicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
