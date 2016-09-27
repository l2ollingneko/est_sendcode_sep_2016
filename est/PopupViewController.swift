//
//  PopupViewController.swift
//  est
//
//  Created by warinporn khantithamaporn on 9/27/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {
    
    var popupImageView = UIImageView(frame: CGRectMake(0.0, 0.0, Est.calculatedWidthFromRatio(1242.0), Est.calculatedHeightFromRatio(2208.0)))
    var closeImageView = UIImageView()
    var closeButton = UIButton()
    var shareButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clearColor()
        self.view.clipsToBounds = true
        
        self.view.addSubview(self.popupImageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initPopup() {
        self.popupImageView.userInteractionEnabled = true
        
        self.closeImageView.frame = Est.calculatedRectFromRatio(1090.0, y: 723.0, w: 54.0, h: 57.0)
        self.closeImageView.image = UIImage(named: "popup_close_button")
        self.closeImageView.backgroundColor = UIColor.clearColor()
        
        self.closeButton.frame = Est.calculatedRectFromRatio(1077.0, y: 711.5, w: 80.0, h: 80.0)
        self.closeButton.addTarget(self, action: #selector(PopupViewController.close), forControlEvents: .TouchUpInside)
        self.closeButton.backgroundColor = UIColor.clearColor()
        
        self.popupImageView.addSubview(self.closeImageView)
        self.popupImageView.addSubview(self.closeButton)
    }
    
    /* MARK: - initpopup
        type - 0, thank
             - 1, soon
             - 2, loser
             - 3, winner
             - 4, tvc
    */
    func initPopup(type: Int) {
        
        self.initPopup()
        
        switch type {
            case 0:
                self.popupImageView.image = UIImage(named: "thank_popup")
                self.initSendMoreButton()
                // MARK: - googleanalytics
                AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Page, action: .Opened, label: "estSendCode-ThankYou")
            case 1:
                self.popupImageView.image = UIImage(named: "soon_popup")
                self.initShareButton()
                // MARK: - googleanalytics
                AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Page, action: .Opened, label: "estSoonCheckWinnerPopup")
            case 2:
                self.popupImageView.image = UIImage(named: "loser_popup")
                self.initShareButton()
                // MARK: - googleanalytics
                AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Page, action: .Opened, label: "estSendCode-NotPrize")
            case 3:
                self.popupImageView.image = UIImage(named: "winner_popup")
                self.initShareButton()
                // MARK: - googleanalytics
                AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Page, action: .Opened, label: "estSendCode-WinSeat")
            default:
                // MARK: - googleanalytics
                AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Page, action: .Opened, label: "estSendCode-TVC")
                break
        }
    }
    
    func initSendMoreButton() {
        self.shareButton.frame = Est.calculatedRectFromRatio(0.0, y: 1436.0, w: 1242.0, h: 210.0)
        self.shareButton.setImage(UIImage(named: "send_more_code_button"), forState: .Normal)
        self.shareButton.addTarget(self, action: #selector(PopupViewController.closeAndPresentSendCode), forControlEvents: .TouchUpInside)
        
        self.popupImageView.addSubview(self.shareButton)
    }
    
    func initShareButton() {
        self.shareButton.frame = Est.calculatedRectFromRatio(0.0, y: 1436.0, w: 1242.0, h: 210.0)
        self.shareButton.setImage(UIImage(named: "popup_fb_share_button"), forState: .Normal)
        self.shareButton.addTarget(self, action: #selector(PopupViewController.share), forControlEvents: .TouchUpInside)
        self.popupImageView.addSubview(self.shareButton)
    }
    
    func initWinnerPopup() {
        
    }
    
    func share() {
        // TODO: - need fb here
    }
    
    func close() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func closeAndPresentSendCode() {
        self.dismissViewControllerAnimated(false, completion: nil)
        ControllerManager.sharedInstance.presentSendCode()
    }

}
