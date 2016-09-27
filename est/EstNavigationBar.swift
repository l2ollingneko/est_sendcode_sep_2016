//
//  EstNavigationBar.swift
//  est
//
//  Created by warinporn khantithamaporn on 9/20/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

protocol EstNavigationBarDelegate {
    func menuDidTap()
    func notiDidTap()
}

class EstNavigationBar: UIView {
    
    var backgroundImageView = UIImageView()
    var logoImageView = UIImageView()
    
    var menuButton = UIButton()
    var menuImageView = UIImageView()
    
    var notiButton = UIButton()
    var notiImageView = UIImageView()
    
    var badge = UIImageView()
    
    var delegate: EstNavigationBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init() {
        super.init(frame: CGRectMake(0.0, 0.0, Est.rWidth, Est.calculatedHeightFromRatio(168.0)))
        
        self.backgroundColor = UIColor.clearColor()
        
        self.backgroundImageView.frame = self.frame
        self.backgroundImageView.image = UIImage(named: "navbar")
        
        self.badge.frame = Est.calculatedRectFromRatio(1148.0, y: 34.0, w: 67.0, h: 68.0)
        
        self.menuButton.frame = CGRectMake(0.0, 0.0, Est.calculatedWidthFromRatio(168.0), Est.calculatedHeightFromRatio(168.0))
        self.menuButton.addTarget(self, action: #selector(EstNavigationBar.menu(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.notiButton.frame = CGRectMake(Est.rWidth - Est.calculatedWidthFromRatio(168.0), 0.0, Est.calculatedWidthFromRatio(168.0), Est.calculatedHeightFromRatio(168.0))
        self.notiButton.addTarget(self, action: #selector(EstNavigationBar.noti(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.addSubview(self.backgroundImageView)
        self.addSubview(self.menuButton)
        self.addSubview(self.notiButton)
        self.addSubview(self.badge)
    }
    
    init(custom: Bool) {
        super.init(frame: CGRectMake(0.0, 0.0, Est.rWidth, Est.calculatedHeightFromRatio(174.0)))
        
        self.backgroundImageView.frame = self.frame
        self.backgroundImageView.image = UIImage(named: "menu_navbar")
        
        self.backgroundColor = UIColor.clearColor()
        self.backgroundImageView.backgroundColor = UIColor.clearColor()
        
        self.badge.frame = Est.calculatedRectFromRatio(1148.0, y: 34.0, w: 67.0, h: 68.0)
        
        self.menuButton.frame = CGRectMake(0.0, 0.0, Est.calculatedWidthFromRatio(174.0), Est.calculatedHeightFromRatio(174.0))
        self.menuButton.addTarget(self, action: #selector(EstNavigationBar.menu(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.notiButton.frame = CGRectMake(Est.rWidth - Est.calculatedWidthFromRatio(174.0), 0.0, Est.calculatedWidthFromRatio(174.0), Est.calculatedHeightFromRatio(174.0))
        self.notiButton.addTarget(self, action: #selector(EstNavigationBar.noti(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.addSubview(self.backgroundImageView)
        self.addSubview(self.menuButton)
        self.addSubview(self.notiButton)
        self.addSubview(self.badge)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func menu(button: UIButton) {
        AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "Click_menu")
        self.delegate?.menuDidTap()
    }
    
    func noti(button: UIButton) {
        AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "BT_announce")
        self.delegate?.notiDidTap()
    }
    
}
