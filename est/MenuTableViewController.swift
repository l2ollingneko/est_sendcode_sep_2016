//
//  MenuTableViewController.swift
//  est
//
//  Created by warinporn khantithamaporn on 9/24/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKShareKit
import SwiftyJSON

class MenuTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, EstNavigationBarDelegate, FBSDKSharingDelegate {
    
    var navbar = EstNavigationBar(custom: true)
    var tableView = UITableView(frame: CGRectMake(0.0, Est.calculatedHeightFromRatio(174.0), Est.calculatedWidthFromRatio(1242.0), Est.calculatedHeightFromRatio(2208.0)), style: .Plain)
    var backgroundImageView = UIImageView(frame: CGRectMake(0.0, 0.0, Est.calculatedWidthFromRatio(1242.0), Est.calculatedHeightFromRatio(2208.0)))
    
    var currentIndex: Int?
    
    var menu: [String] = [
        "sendcode",
        "rule",
        "howto",
        "tvc",
        "check",
        "share",
        "home"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navbar.delegate = self
        
        self.view.backgroundColor = UIColor.clearColor()
        self.view.clipsToBounds = true
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.clipsToBounds = true
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .None
        self.tableView.bounces = false
        
        self.tableView.registerNib(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "menuCell")
        
        self.tableView.backgroundColor = UIColor.clearColor()
        
        self.backgroundImageView.image = UIImage(named: "menu_only_bg")
        
        self.view.addSubview(self.backgroundImageView)
        self.view.addSubview(self.navbar)
        self.view.addSubview(self.tableView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (Est.sharedInstance.badgeCounter > 0) {
            self.getAnnounceRound()
        }
        
        AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Page, action: .Opened, label: "estSendCode-Menu")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - tableview
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("menuCell", forIndexPath: indexPath) as! MenuTableViewCell
        if let index = self.currentIndex {
            if (indexPath.row == index) {
                cell.initCell(self.menu[indexPath.row], on: true)
            } else {
                cell.initCell(self.menu[indexPath.row])
            }
        } else { 
            cell.initCell(self.menu[indexPath.row])
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Est.calculatedHeightFromRatio(216.0)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 0) {
            self.dismissViewControllerAnimated(false, completion: nil)
            ControllerManager.sharedInstance.presentSendCode()
            AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "Menu_sendcode")
        } else if (indexPath.row == 1) {
            self.dismissViewControllerAnimated(false, completion: nil)
            ControllerManager.sharedInstance.presentWebView(.Rule)
            AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Page, action: .Opened, label: "estSendCode-Rule")
            AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "Menu_rule")
        } else if (indexPath.row == 2) {
            self.dismissViewControllerAnimated(false, completion: nil)
            ControllerManager.sharedInstance.presentWebView(.HowTo)
            AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Page, action: .Opened, label: "estSendCode-How")
            AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "Menu_how")
        } else if (indexPath.row == 3) {
            // TODO: - tvc
            self.dismissViewControllerAnimated(false, completion: nil)
            ControllerManager.sharedInstance.presentWebView(.Tvc)
            AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "Menu_tvc")
        } else if (indexPath.row == 4) {
            self.dismissViewControllerAnimated(false, completion: nil)
            ControllerManager.sharedInstance.presentCheckWinner()
            AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "Menu_checkwin")
        } else if (indexPath.row == 5) {
            // TODO: - share
            self.shareFBDidTap()
            AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "Menu_share")
        } else {
            // TODO: - home
            AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "Menu_home")
        }
    }
    
    // MARK: - tableview header
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Est.calculatedHeightFromRatio(88.0)
    }
    
    func menuDidTap() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func notiDidTap() {
        ControllerManager.sharedInstance.presentCheckWinner()
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
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
        let contentImg = NSURL(string: DataManager.sharedInstance.getObjectForKey("share_image") as! String)
        let contentURL = NSURL(string: DataManager.sharedInstance.getObjectForKey("share_url") as! String)
        let contentTitle = DataManager.sharedInstance.getObjectForKey("share_title") as! String
        let contentDescription = DataManager.sharedInstance.getObjectForKey("share_description") as! String
        
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
    
    // MARK: - api
    
    func getAnnounceRound() {
        EstHTTPService.sharedInstance.getAnnounceRound(Callback() { (round, success, errorString, error) in
            if (success) {
                if let currentBadge = DataManager.sharedInstance.getObjectForKey("current_badge") {
                    let badge = currentBadge as! Int
                    print("badge: \(badge), estBadge: \(Est.sharedInstance.badgeCounter)")
                    if (badge < Est.sharedInstance.badgeCounter) {
                        self.navbar.badge.image = UIImage(named: "red_\(Est.sharedInstance.badgeCounter)")
                    } else {
                        self.navbar.badge.image = UIImage(named: "black_\(badge)")
                    }
                } else {
                    DataManager.sharedInstance.setObjectForKey(0, key: "current_badge")
                    // TODO: - show est badge counter
                    // self.navbar.badge.image = UIImage(named: "red_\(Est.sharedInstance.badgeCounter)")
                }
            } else {
                
            }
        })
    }
    
}
