//
//  CheckWinnerViewController.swift
//  est
//
//  Created by warinporn khantithamaporn on 9/25/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

class CheckWinnerViewController: EstTableViewController {
    
    var backgroundTableView = UITableView()
    
    var phoneNumber: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.backgroundTableView.frame = CGRectMake(0.0, 0.0, Est.rWidth, Est.rHeight)
        self.backgroundTableView.dataSource = self
        self.backgroundTableView.delegate = self
        self.backgroundTableView.userInteractionEnabled = false
        
        // self.backgroundTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "backgroundCell")
        self.backgroundTableView.registerNib(UINib(nibName: "CheckWinnerBackgroundTableViewCell", bundle: nil), forCellReuseIdentifier: "backgroundCell")
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.registerNib(UINib(nibName: "PhoneNumberTableViewCell", bundle: nil), forCellReuseIdentifier: "phoneNumberCell")
        self.tableView.registerNib(UINib(nibName: "SendButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "sendButtonCell")
        self.tableView.registerNib(UINib(nibName: "AnnounceTableViewCell", bundle: nil), forCellReuseIdentifier: "announceCell")
        
        self.tableView.bounces = false
        self.backgroundTableView.bounces = false
        self.tableView.separatorStyle = .None
        
        self.tableView.backgroundColor = UIColor.clearColor()
        
        self.view.addSubview(self.backgroundTableView)
        self.view.sendSubviewToBack(self.backgroundTableView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // MARK: - get phone number from userdefault
        if let phoneNumberObject = DataManager.sharedInstance.getObjectForKey("phone_number") {
            let phoneNumber = phoneNumberObject as! String
            if (self.checkValidPhoneNumber(phoneNumber)) {
                self.phoneNumber = phoneNumber
                self.tableView.reloadData()
            }
        }
        
        // MARK: - googleanalytics
        AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Page, action: .Opened, label: "estSendCode-CheckWin")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (tableView.isEqual(self.tableView)) {
            return 1
        } else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView.isEqual(self.tableView)) {
            return 8
        } else {
            return 1
        }

    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (tableView.isEqual(self.tableView)) {
            if (indexPath.row == 0) {
                let cell = tableView.dequeueReusableCellWithIdentifier("phoneNumberCell", forIndexPath: indexPath) as! PhoneNumberTableViewCell
                cell.initCell(true)
                cell.textField.delegate = self
                cell.textField.text = self.phoneNumber
                return cell
            } else if (indexPath.row == 1) {
                let cell = tableView.dequeueReusableCellWithIdentifier("sendButtonCell", forIndexPath: indexPath) as! SendButtonTableViewCell
                cell.initCell(true)
                return cell
            } else if (indexPath.row == 2 || indexPath.row == 7) {
                let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
                cell.backgroundColor = UIColor.clearColor()
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("announceCell", forIndexPath: indexPath) as! AnnounceTableViewCell
                cell.initCell()
                // let colors = [UIColor.redColor(), UIColor.blueColor(), UIColor.purpleColor(), UIColor.blackColor()]
                // cell.backgroundColor = colors[indexPath.row - 3].colorWithAlphaComponent(0.5)
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("backgroundCell", forIndexPath: indexPath) as! CheckWinnerBackgroundTableViewCell
            cell.initCell(4)
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (tableView.isEqual(self.tableView)) {
            if (indexPath.row == 0) {
                return Est.calculatedHeightFromRatio(1144.0)
            } else if (indexPath.row == 1) {
                return Est.calculatedHeightFromRatio(256.0)
            } else if (indexPath.row == 2) {
                return Est.calculatedHeightFromRatio(246.0)
            } else if (indexPath.row < 7) {
                return Est.calculatedHeightFromRatio(406.0)
            } else {
                return Est.calculatedHeightFromRatio(228.0)
            }
        } else {
            return Est.calculatedHeightFromRatio(3500.0)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.backgroundTableView.contentOffset = scrollView.contentOffset
    }
    
    override func notiDidTap() {
        // do nothing -> current controller
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CheckWinnerViewController: UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newLength = textField.text!.utf16.count + string.utf16.count - range.length
        return newLength <= 10
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if (self.checkValidPhoneNumber(textField.text!)) {
            print("valid phone number")
            DataManager.sharedInstance.setObjectForKey(textField.text!, key: "phone_number")
        } else {
            print("invalid phone number")
        }
    }
    
}
