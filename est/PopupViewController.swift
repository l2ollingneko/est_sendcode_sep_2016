//
//  PopupViewController.swift
//  est
//
//  Created by warinporn khantithamaporn on 9/27/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit
import THLabel
import FBSDKLoginKit
import FBSDKShareKit
import SwiftyJSON

enum ShareMode {
    case Share, ShareResult, ShareWinner, ShareNotWinner
}

class PopupViewController: UIViewController, FBSDKSharingDelegate {
    
    var popupImageView = UIImageView(frame: CGRectMake(0.0, 0.0, Est.calculatedWidthFromRatio(1242.0), Est.calculatedHeightFromRatio(2208.0)))
    var closeImageView = UIImageView()
    var closeButton = UIButton()
    var shareButton = UIButton()
    
    // MARK: - loser
    var prizeCountLabel = THLabel()
    
    // MARK: - winner
    var roundLabel = THLabel()
    var codeLabel = UILabel()
    var roundDateImageView = UIImageView()
    
    var mode: ShareMode = .Share

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
                self.mode = .ShareResult
                self.popupImageView.image = UIImage(named: "soon_popup")
                self.initShareButton()
                // MARK: - googleanalytics
                AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Page, action: .Opened, label: "estSoonCheckWinnerPopup")
            case 2:
                self.mode = .ShareNotWinner
                self.popupImageView.image = UIImage(named: "loser_popup")
                self.initShareButton()
                self.initLoserPopup()
                // MARK: - googleanalytics
                AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Page, action: .Opened, label: "estSendCode-NotPrize")
            case 3:
                self.mode = .ShareWinner
                self.popupImageView.image = UIImage(named: "winner_popup")
                self.initShareButton()
                self.closeButton.frame = Est.calculatedRectFromRatio(1077.0, y: 592.0, w: 80.0, h: 80.0)
                self.closeImageView.frame = Est.calculatedRectFromRatio(1090.0, y: 603.5, w: 54.0, h: 57.0)
                self.initWinnerPopup(0)
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
        self.shareButton.addTarget(self, action: #selector(PopupViewController.shareFBDidTap), forControlEvents: .TouchUpInside)
        self.popupImageView.addSubview(self.shareButton)
    }
    
    func initLoserPopup() {
        self.prizeCountLabel.frame = Est.calculatedRectFromRatio(884.0, y: 1276.0, w: 100.0, h: 60.0)
        self.prizeCountLabel.font = UIFont(name: Est.DBHELVETHAICA_X_BOLD_ITALIC, size: Est.calculatedHeightFromRatio(74.0))
        self.prizeCountLabel.textColor = Est.EST_YELLOW
        self.prizeCountLabel.strokeColor = UIColor.blackColor()
        self.prizeCountLabel.strokeSize = Est.calculatedWidthFromRatio(10.0)
        self.prizeCountLabel.textAlignment = .Center
        
        self.prizeCountLabel.transform = CGAffineTransformMakeRotation(CGFloat(M_PI) * 1.969)
        
        self.popupImageView.addSubview(self.prizeCountLabel)
    }
    
    func initWinnerPopup(round: Int) {
        self.roundDateImageView.frame = Est.calculatedRectFromRatio(0.0, y: 1347.0, w: 1242.0, h: 64.0)
        
        self.codeLabel.frame = Est.calculatedRectFromRatio(370.0, y: 1260.0, w: 546.0, h: 42.0)
        self.codeLabel.font = UIFont(name: Est.DBHELVETHAICA_X_BOLD, size: Est.calculatedHeightFromRatio(74.0))
        self.codeLabel.textColor = UIColor.darkGrayColor()
        self.codeLabel.textAlignment = .Center
        
        self.roundLabel.frame = Est.calculatedRectFromRatio(930.0, y: 1100.0, w: 60.0, h: 60.0)
        self.roundLabel.font = UIFont(name: Est.DBHELVETHAICA_X_BOLD, size: Est.calculatedHeightFromRatio(70.0))
        self.roundLabel.textColor = UIColor.whiteColor()
        self.roundLabel.textAlignment = .Center
        self.roundLabel.strokeSize = Est.calculatedWidthFromRatio(10.0)
        self.roundLabel.strokeColor = UIColor.blackColor()
        
        self.popupImageView.addSubview(self.roundDateImageView)
        self.popupImageView.addSubview(self.codeLabel)
        self.popupImageView.addSubview(self.roundLabel)
    }
    
    func share() {
        // TODO: - need fb here
    }
    
    func close() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func closeAndPresentSendCode() {
        AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "Click_AddCode")
        self.dismissViewControllerAnimated(false, completion: nil)
        ControllerManager.sharedInstance.presentSendCode()
    }
    
    // MARK: - fb
    
    // MARK: - fb share
    
    func shareFBDidTap() {
        // OtificationGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "bnt_main_share-FB")
        if let _ = FBSDKAccessToken.currentAccessToken() {
            let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email,gender,link,first_name,last_name"], HTTPMethod: "GET")
            let connection = FBSDKGraphRequestConnection()
            connection.addRequest(request, completionHandler: { (conn, result, error) -> Void in
                if (error != nil) {
                    print("\(error.localizedDescription)")
                } else {
                    var json = JSON(result)
                    
                    // var params = Dictionary<String, AnyObject>()
                    if let firstname = json["first_name"].string {
                        DataManager.sharedInstance.setObjectForKey(firstname, key: "first_name")
                    }
                    
                    if let lastname = json["last_name"].string {
                        DataManager.sharedInstance.setObjectForKey(lastname, key: "last_name")
                    }
                    
                    if let email = json["email"].string {
                        DataManager.sharedInstance.setObjectForKey(email, key: "email")
                    }
                    
                    if let gender = json["gender"].string {
                        DataManager.sharedInstance.setObjectForKey(gender, key: "gender")
                    }
                    
                    if let link = json["link"].string {
                        DataManager.sharedInstance.setObjectForKey(link, key: "link")
                    }
                    
                    self.shareFacebookResult()
                }
            })
            
            connection.start()
        } else {
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            
            loginManager.loginBehavior = FBSDKLoginBehavior.Browser
            
            loginManager.logInWithReadPermissions(["public_profile", "email", "user_about_me"], fromViewController: self, handler: {
                (result: FBSDKLoginManagerLoginResult!, error: NSError?) -> Void in
                if (error != nil) {
                    // fb login error
                } else if (result.isCancelled) {
                    // fb login cancelled
                } else if (result.declinedPermissions.contains("public_profile") || result.declinedPermissions.contains("email") || result.declinedPermissions.contains("user_about_me")) {
                    // declined "public_profile", "email" or "user_about_me"
                } else {
                    // TODO: api to update facebookid-nontoken
                    _ = FBSDKAccessToken.currentAccessToken().userID
                    let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email,gender,link,first_name,last_name"], HTTPMethod: "GET")
                    let connection = FBSDKGraphRequestConnection()
                    connection.addRequest(request, completionHandler: { (conn, result, error) -> Void in
                        if (error != nil) {
                            print("\(error.localizedDescription)")
                        } else {
                            var json = JSON(result)
                            
                            // var params = Dictionary<String, AnyObject>()
                            
                            if let firstname = json["first_name"].string {
                                DataManager.sharedInstance.setObjectForKey(firstname, key: "first_name")
                            }
                            
                            if let lastname = json["last_name"].string {
                                DataManager.sharedInstance.setObjectForKey(lastname, key: "last_name")
                            }
                            
                            if let email = json["email"].string {
                                DataManager.sharedInstance.setObjectForKey(email, key: "email")
                            }
                            
                            if let gender = json["gender"].string {
                                DataManager.sharedInstance.setObjectForKey(gender, key: "gender")
                            }
                            
                            if let link = json["link"].string {
                                DataManager.sharedInstance.setObjectForKey(link, key: "link")
                            }
                            
                            // OtificationHTTPService.sharedInstance.updateFacebookIDNonToken(KeychainWrapper.defaultKeychainWrapper().stringForKey("fbuid")!)
                            
                            self.shareFacebookResult()
                        }
                    })
                    connection.start()
                }
            })
        }
    }
    
    func shareFacebookResult() {
        
        var prefix = ""
        
        if (self.mode == .ShareResult) {
            // soon
            AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "Click_ShareSoonCheckWinnerPopup")
            prefix = "shareresult"
        } else if (self.mode == .ShareWinner) {
            // winner
            AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "Click_ShareSuccessWinSeat")
            EstHTTPService.sharedInstance.saveFBShareForWinner()
            prefix = "sharewinner"
        } else if (self.mode == .ShareNotWinner) {
            // not winner
            AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "Click_ShareNotPrize")
            prefix = "sharenotwin"
        }
        
        let contentImg = NSURL(string: DataManager.sharedInstance.getObjectForKey("\(prefix)_image") as! String)
        let contentURL = NSURL(string: DataManager.sharedInstance.getObjectForKey("\(prefix)_url") as! String)
        let contentTitle = DataManager.sharedInstance.getObjectForKey("\(prefix)_title") as! String
        let contentDescription = DataManager.sharedInstance.getObjectForKey("\(prefix)_description") as! String
        
        let photoContent: FBSDKShareLinkContent = FBSDKShareLinkContent()
        
        photoContent.contentURL = contentURL
        photoContent.contentTitle = contentTitle
        photoContent.contentDescription = contentDescription
        photoContent.imageURL = contentImg
        
        let dialog = FBSDKShareDialog()
        dialog.mode = FBSDKShareDialogMode.FeedBrowser
        dialog.shareContent = photoContent
        dialog.delegate = self
        dialog.fromViewController = self
        
        dialog.show()
    }
    
    func sharerDidCancel(sharer: FBSDKSharing!) {
        print("didCancel")
    }
    
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!) {
        print("didFailWithError: \(error.localizedDescription)")
    }
    
    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        print("didCompleteWithResults")
        if let _ = results["postId"] {
            /*
            OtificationHTTPService.sharedInstance.saveFBShare(results["postId"] as! String)
            OtificationHTTPService.sharedInstance.shareResult()
            self.popup = PopupThankyouView(frame: CGRectMake(0.0, 0.0, Otification.rWidth, Otification.rHeight))
            popup?.isOnlyThankyou = true
            popup?.initPopupView()
            self.view.addSubview(popup!)
             */
        }
    }

}
