//
//  EstTableViewController.swift
//  est
//
//  Created by warinporn khantithamaporn on 9/20/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit
import SwiftyJSON

class EstTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, EstNavigationBarDelegate {
    
    var navBar: EstNavigationBar = EstNavigationBar()
    var tableView: UITableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.frame = CGRectMake(0.0, 0.0, Est.rWidth, Est.rHeight)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.view.addSubview(self.tableView)
        
        self.view.addSubview(self.navBar)
        self.view.bringSubviewToFront(self.navBar)
        
        self.tableView.keyboardDismissMode = .OnDrag
        
        self.navBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("", forIndexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 0.0
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - estnavigationbardelegate
    
    func menuDidTap() {
        let menu = MenuTableViewController(nibName: "MenuTableViewController", bundle: nil)
        menu.modalPresentationStyle = .OverCurrentContext
        self.definesPresentationContext = true
        self.presentViewController(menu, animated: false, completion: nil)
        
        // MARK: - googleanalytics
        AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "Click_menu")
    }
    
    func notiDidTap() {
        ControllerManager.sharedInstance.presentCheckWinner()
    }

    // MARK: - check phone number
    
    func checkValidPhoneNumber(phoneNumber: String) -> Bool {
        if (phoneNumber.characters.count == 10) {
            let infix = phoneNumber.substringToIndex(phoneNumber.startIndex.advancedBy(2))
            if (infix == "08" || infix == "06" || infix == "09") {
                return true
            }
        }
        return false
    }
    
}
