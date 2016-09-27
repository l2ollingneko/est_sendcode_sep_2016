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
    
    var activeTextField: UITextField?
    var phoneNumberCell: PhoneNumberTableViewCell?
    var sendButtonCell: SendButtonTableViewCell?
    var popupAlertView: EstPopupAlertView?
    
    var phoneNumber: String = ""
    var sendable: Bool = false
    
    var currentIndex: Int = 1
    
    // MARK: - models, lazy implementation
    
    var winners = [String]()
    var dateText = [String]()
    var status = [String]()
    var url = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.clearColor()
        self.view.clipsToBounds = true
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.clipsToBounds = true
        self.backgroundTableView.backgroundColor = UIColor.clearColor()
        self.backgroundTableView.clipsToBounds = true
        
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
        
        self.tableView.removeGestureRecognizer(self.tapRecognizer!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (Est.sharedInstance.badgeCounter > 0) {
            DataManager.sharedInstance.setObjectForKey(Est.sharedInstance.badgeCounter, key: "current_badge")
            self.getAnnounceRound()
        }
        
        self.getWinnerAnnounce()
        
        // MARK: - get phone number from userdefault
        if let phoneNumberObject = DataManager.sharedInstance.getObjectForKey("phone_number") {
            let phoneNumber = phoneNumberObject as! String
            if (self.checkValidPhoneNumber(phoneNumber)) {
                self.phoneNumber = phoneNumber
                self.tableView.reloadData()
                self.sendable = true
            }
        } else {
            self.sendable = false
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
                self.activeTextField = cell.textField
                self.phoneNumberCell = cell
                return cell
            } else if (indexPath.row == 1) {
                let cell = tableView.dequeueReusableCellWithIdentifier("sendButtonCell", forIndexPath: indexPath) as! SendButtonTableViewCell
                cell.initCell(true)
                cell.delegate = self
                
                if (self.sendable) {
                    cell.sendButton.enabled = true
                } else {
                    cell.sendButton.enabled = false
                }
                
                self.sendButtonCell = cell
                return cell
            } else if (indexPath.row == 2 || indexPath.row == 7) {
                let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
                cell.backgroundColor = UIColor.clearColor()
                cell.selectionStyle = .None
                return cell
            } else {
                // row -> 3, 4, 5 and 6
                let cell = tableView.dequeueReusableCellWithIdentifier("announceCell", forIndexPath: indexPath) as! AnnounceTableViewCell
                // cell.initCell()
                if (self.status.count > 0) {
                    cell.initCell(self.dateText[indexPath.row - 3], type: 1)
                    /*
                    if (self.status[indexPath.row - 3] == "true") {
                        if (self.currentIndex - 1 > indexPath.row - 3) {
                            cell.initCell(self.dateText[indexPath.row - 3], type: 1)
                        } else {
                            cell.initCell(self.dateText[indexPath.row - 3], type: 0)
                        }
                    } else {
                        cell.initCell(self.dateText[indexPath.row - 3], type: 1)
                    }
                     */
                }
                // let colors = [UIColor.redColor(), UIColor.blueColor(), UIColor.purpleColor(), UIColor.blackColor()]
                // cell.backgroundColor = colors[indexPath.row - 3].colorWithAlphaComponent(0.5)
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("backgroundCell", forIndexPath: indexPath) as! CheckWinnerBackgroundTableViewCell
            cell.initCell(self.currentIndex)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (tableView.isEqual(self.tableView)) {
            if (indexPath.row >= 3 && indexPath.row <= 6) {
                print("check a, url.count: \(indexPath.row - 2) \(self.url.count)")
                if (indexPath.row - 2 <= self.url.count) {
                    if let requestUrl = NSURL(string: self.url[indexPath.row - 3]) {
                        UIApplication.sharedApplication().openURL(requestUrl)
                    }
                }
            }
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
    
    func checkValidPhoneNumber(phoneNumber: String) -> Bool {
        if (phoneNumber.characters.count == 10) {
            print("check a")
            let infix = phoneNumber.substringToIndex(phoneNumber.startIndex.advancedBy(2))
            if (infix == "08" || infix == "06" || infix == "09") {
                print("check b")
                self.sendable = true
                return true
            }
        }
        self.sendable = false
        return false
    }
    
    // MARK: - api
    
    func getWinnerAnnounce() {
        EstHTTPService.sharedInstance.checkWinnerAnnounce(Callback() { (jsons, success, errorString, error) in
            if (success) {
                self.winners.removeAll()
                self.dateText.removeAll()
                self.status.removeAll()
                self.url.removeAll()
                self.currentIndex = 1
                for (index, json) in jsons!.enumerate() {
                    print("index: \(index)")
                    print(json)
                    if let winner = json["winner"].string {
                        self.winners.append(winner)
                    }
                    if let date = json["datetext"].string {
                        self.dateText.append(date)
                    }
                    if let status = json["status"].string {
                        print("status: \(status)")
                        self.status.append(status)
                        if (status == "true") {
                            self.currentIndex = index + 2
                        }
                    }
                    if let url = json["url"].string where url != "" {
                        self.url.append(url)
                    }
                }
                self.tableView.reloadData()
                self.backgroundTableView.reloadData()
            }
        })
    }
    
    func getAnnounceRound() {
        EstHTTPService.sharedInstance.getAnnounceRound(Callback() { (round, success, errorString, error) in
            if (success) {
                if let currentBadge = DataManager.sharedInstance.getObjectForKey("current_badge") {
                    let badge = currentBadge as! Int
                    print("badge: \(badge), estBadge: \(Est.sharedInstance.badgeCounter)")
                    if (badge < Est.sharedInstance.badgeCounter) {
                        self.navBar.badge.image = UIImage(named: "red_\(Est.sharedInstance.badgeCounter)")
                    } else {
                        self.navBar.badge.image = UIImage(named: "black_\(badge)")
                    }
                } else {
                    DataManager.sharedInstance.setObjectForKey(0, key: "current_badge")
                    // TODO: - show est badge counter
                    self.navBar.badge.image = UIImage(named: "red_\(Est.sharedInstance.badgeCounter)")
                }
            } else {
                
            }
        })
    }
    
    // MARK: - popup
    
    func presentWinnerPopup(round: String, code: String) {
        let popup = PopupViewController(nibName: "PopupViewController", bundle: nil)
        popup.modalPresentationStyle = .OverCurrentContext
        popup.initPopup(3)
        popup.roundDateImageView.image = UIImage(named: "winner_round_\(round)")
        popup.codeLabel.text = code
        popup.roundLabel.text = round
        self.definesPresentationContext = true
        self.presentViewController(popup, animated: false, completion: nil)
    }
    
    func presentLoserPopup(prizeCount: String) {
        let popup = PopupViewController(nibName: "PopupViewController", bundle: nil)
        popup.modalPresentationStyle = .OverCurrentContext
        popup.initPopup(2)
        popup.prizeCountLabel.text = prizeCount
        self.definesPresentationContext = true
        self.presentViewController(popup, animated: false, completion: nil)
    }
    
    func presentSoonPopup() {
        let popup = PopupViewController(nibName: "PopupViewController", bundle: nil)
        popup.modalPresentationStyle = .OverCurrentContext
        popup.initPopup(1)
        self.definesPresentationContext = true
        self.presentViewController(popup, animated: false, completion: nil)
    }
    
    override func menuDidTap() {
        let menu = MenuTableViewController(nibName: "MenuTableViewController", bundle: nil)
        menu.modalPresentationStyle = .OverCurrentContext
        menu.currentIndex = 4
        self.definesPresentationContext = true
        self.presentViewController(menu, animated: false, completion: nil)
        
        self.activeTextField?.resignFirstResponder()
        
        // MARK: - googleanalytics
        AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "Click_menu")
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

extension CheckWinnerViewController: SendButtonTableViewCellDelegate {

    func checkButtonDidTap() {
        
        if (!Reachability.isConnectedToNetwork()) {
            self.showPopupAlertView("กรุณาตรวจสอบสัญญาณอินเทอร์เน็ต")
            return
        }
        
        // MARK: - googleanalytics
        AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "Click_check")
        
        if (self.activeTextField != nil) {
            if (self.activeTextField?.text != nil && self.activeTextField!.text?.characters.count == 10) {
                if (self.checkValidPhoneNumber(self.activeTextField!.text!)) {
                    self.phoneNumber = self.activeTextField!.text!
                }
            }
        }
        
        if (self.checkValidPhoneNumber(self.phoneNumber)) {
            print("valid phone number")
            EstHTTPService.sharedInstance.checkWinner(self.phoneNumber, cb: Callback() { (json, success, string, error) in
                if (success) {
                    print("success")
                    if (string == "winner") {
                        // MARK: - popup winner
                        let round = json!["round"].string
                        let code = json!["code"].string
                        self.presentWinnerPopup(round!, code: code!)
                    } else if (string == "notwinner") {
                        // MARK: - popup notwinner
                        let prizeCount = json!["detail"].string
                        self.presentLoserPopup(prizeCount!)
                    } else {
                        // MARK: - soon
                        self.presentSoonPopup()
                    }
                } else {
                    print("fail")
                    // MARK: - popup error
                }
            })
        } else {
            print("invalid phone number")
        }
        
    }
    
    // MARK: - estpopupalertview
    
    func showPopupAlertView(message: String) {
        if (self.popupAlertView == nil) {
            self.popupAlertView = EstPopupAlertView(frame: CGRectZero)
            self.popupAlertView?.initMessage(message)
            self.popupAlertView?.layer.zPosition = 1000
            self.popupAlertView?.alpha = 0.0
            
            self.view.addSubview(self.popupAlertView!)
            
            UIView.animateWithDuration(0.2,
                animations: {
                    self.popupAlertView?.alpha = 0.0
                    self.popupAlertView?.alpha = 1.0
                }, completion: { finished in
                    NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(3.0), target: self, selector: #selector(SendCodeTableViewController.removePopupAlertView), userInfo: nil, repeats: false)
            })
        }
    }
    
    func removePopupAlertView() {
        UIView.animateWithDuration(0.2,
            animations: {
                self.popupAlertView?.alpha = 1.0
                self.popupAlertView?.alpha = 0.0
            }, completion: { finished in
                self.popupAlertView?.removeFromSuperview()
                self.popupAlertView = nil
        })
    }
    
}

extension CheckWinnerViewController: UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = NSCharacterSet(charactersInString: "0123456789").invertedSet
        let newLength = textField.text!.utf16.count + string.utf16.count - range.length
        return (string.rangeOfCharacterFromSet(invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil) && (newLength <= 10)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.activeTextField = textField
        self.tableView.addGestureRecognizer(self.tapRecognizer!)
        if (self.sendable) {
            self.phoneNumber = textField.text!
            self.sendable = false
            self.sendButtonCell?.sendButton.enabled = false
            self.phoneNumberCell?.checkMarkImageView.hidden = true
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.tableView.removeGestureRecognizer(self.tapRecognizer!)
        if (self.checkValidPhoneNumber(textField.text!)) {
            print("valid phone number")
            self.phoneNumber = textField.text!
            DataManager.sharedInstance.setObjectForKey(textField.text!, key: "phone_number")
            // TODO: - show check mark & enable button
            self.sendable = true
            self.phoneNumberCell?.checkMarkImageView.hidden = false
        } else {
            print("invalid phone number")
            // TODO: - unable button
            self.phoneNumber = textField.text!
            self.sendable = false
            self.showPopupAlertView("เบอร์โทรศัพท์มือถือไม่ถูกต้อง")
            self.phoneNumberCell?.checkMarkImageView.hidden = true
        }
        self.tableView.reloadData()
    }
    
}
