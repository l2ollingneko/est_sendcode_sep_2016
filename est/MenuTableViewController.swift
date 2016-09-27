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

class MenuTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, EstNavigationBarDelegate {
    
    var navbar = EstNavigationBar(custom: true)
    var tableView = UITableView(frame: CGRectMake(0.0, Est.calculatedHeightFromRatio(174.0), Est.calculatedWidthFromRatio(1242.0), Est.calculatedHeightFromRatio(2208.0)), style: .Plain)
    var backgroundImageView = UIImageView(frame: CGRectMake(0.0, 0.0, Est.calculatedWidthFromRatio(1242.0), Est.calculatedHeightFromRatio(2208.0)))
    
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
        cell.initCell(self.menu[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Est.calculatedHeightFromRatio(216.0)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(false, completion: nil)
        if (indexPath.row == 0) {
            ControllerManager.sharedInstance.presentSendCode()
            AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "Menu_sendcode")
        } else if (indexPath.row == 1) {
            ControllerManager.sharedInstance.presentWebView(.Rule)
            AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Page, action: .Opened, label: "estSendCode-Rule")
            AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "Menu_rule")
        } else if (indexPath.row == 2) {
            ControllerManager.sharedInstance.presentWebView(.HowTo)
            AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Page, action: .Opened, label: "estSendCode-How")
            AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "Menu_how")
        } else if (indexPath.row == 3) {
            // TODO: - tvc
            ControllerManager.sharedInstance.presentWebView(.Tvc)
            AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "Menu_tvc")
        } else if (indexPath.row == 4) {
            ControllerManager.sharedInstance.presentCheckWinner()
            AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "Menu_checkwin")
        } else if (indexPath.row == 5) {
            // TODO: - share
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
    }
    
}
