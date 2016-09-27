//
//  SendCodeTableViewController.swift
//  est
//
//  Created by warinporn khantithamaporn on 9/23/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit
import ReachabilitySwift

class SendCodeTableViewController: EstTableViewController {
    
    var backgroundTableView = UITableView()
    
    var reachability: Reachability?
    
    var activeTextField: UITextField?
    var phoneNumberCell: PhoneNumberTableViewCell?
    var sendButtonCell: SendButtonTableViewCell?
    var loadingIndicator = EstLoadingView(frame: CGRectZero)
    
    var popupAlertView: EstPopupAlertView?

    // MARK: - model data for sendcode
    
    var sendable = false
    var error = false
    var dailyQuota = 0
    
    var phoneNumber: String = ""
    var codes = [Int: String]()
    var error_sendcode = [String: Bool]()
    var sendable_codes = [Int: Bool]()
    var exist_code = [Int]()

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
        
        self.tableView.bounces = false
        self.backgroundTableView.bounces = false
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.registerNib(UINib(nibName: "PhoneNumberTableViewCell", bundle: nil), forCellReuseIdentifier: "phoneNumberCell")
        self.tableView.registerNib(UINib(nibName: "CodeTableViewCell", bundle: nil), forCellReuseIdentifier: "codeCell")
        self.tableView.registerNib(UINib(nibName: "SendButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "sendButtonCell")
        self.tableView.registerNib(UINib(nibName: "NoticeTableViewCell", bundle: nil), forCellReuseIdentifier: "noticeCell")
        
        self.backgroundTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "backgroundCell")
        
        self.tableView.backgroundColor = UIColor.clearColor()
        self.backgroundTableView.backgroundColor = UIColor.clearColor()
        
        self.tableView.separatorStyle = .None
        
        self.view.addSubview(self.backgroundTableView)
        self.view.sendSubviewToBack(self.backgroundTableView)
        
        self.setupReachability()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (Est.sharedInstance.badgeCounter > 0) {
            self.getAnnounceRound()
        }
        
        // MARK: - get phone number from userdefault
        
        if let phoneNumberObject = DataManager.sharedInstance.getObjectForKey("phone_number") {
            let phoneNumber = phoneNumberObject as! String
            if (self.checkValidPhoneNumber(phoneNumber)) {
                self.phoneNumber = phoneNumber
                self.sendable = true
                self.tableView.reloadData()
            } else {
                self.sendable = false
            }
        }
        
        // MARK: - check internet connection
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SendCodeTableViewController.reachabilityChanged(_:)),name: ReachabilityChangedNotification,object: self.reachability)
        do {
            try reachability!.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
    
        // MARK: - googleanalytics
        AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Page, action: .Opened, label: "estSendCode-Submit")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ReachabilityChangedNotification, object: self.reachability)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /*
        // MARK: - test popup
        
        let popup = PopupViewController(nibName: "PopupViewController", bundle: nil)
        popup.modalPresentationStyle = .OverCurrentContext
        popup.initPopup(1)
        self.definesPresentationContext = true
        self.presentViewController(popup, animated: false, completion: nil)
         */
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
            return 14
        } else {
            return 1
        }

    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (tableView.isEqual(self.tableView)) {
            if (indexPath.row == 0) {
                let cell = tableView.dequeueReusableCellWithIdentifier("phoneNumberCell", forIndexPath: indexPath) as! PhoneNumberTableViewCell
                cell.initCell()
                cell.textField.delegate = self
                cell.textField.tag = 99
                cell.textField.text = self.phoneNumber
                self.phoneNumberCell = cell
                return cell
            } else if (indexPath.row == 1) {
                let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
                cell.backgroundColor = UIColor.clearColor()
                cell.selectionStyle = .None
                return cell
            } else if (indexPath.row == 12) {
                let cell = tableView.dequeueReusableCellWithIdentifier("sendButtonCell", forIndexPath: indexPath) as! SendButtonTableViewCell
                cell.initCell()
                cell.delegate = self
                self.sendButtonCell = cell
                
                if (self.error) {
                    cell.errorImageView.hidden = false
                } else {
                    cell.errorImageView.hidden = true
                }
                
                if (self.sendable) {
                    cell.sendButton.enabled = true
                } else {
                    cell.sendButton.enabled = false
                }
                
                return cell
            } else if (indexPath.row == 13) {
                let cell = tableView.dequeueReusableCellWithIdentifier("noticeCell", forIndexPath: indexPath) as! NoticeTableViewCell
                cell.initCell()
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("codeCell", forIndexPath: indexPath) as! CodeTableViewCell
                cell.initCell(indexPath.row - 1, type: 0)
                cell.textField.delegate = self
                cell.textField.tag = indexPath.row - 2
                
                if (self.sendable_codes[cell.textField.tag] != nil)  {
                    if let check :Bool = self.sendable_codes[cell.textField.tag]  {
                        if (check) {
                            cell.initCell(indexPath.row - 1, type: 0)
                        } else {
                            cell.initCell(indexPath.row - 1, type: 2)
                        }
                    } else {
                        cell.initCell(indexPath.row - 1, type: 0)
                    }
                }
                
                if (indexPath.row - 1 > self.dailyQuota || self.dailyQuota == 0 || self.sendable == false) {
                    cell.initCell(indexPath.row - 1, type: 1)
                }
                
                if (self.codes[cell.textField.tag] != nil && self.codes[cell.textField.tag] != "")   {
                    cell.textField.text = self.codes[cell.textField.tag]
                } else {
                    cell.textField.text = nil
                }
                
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("backgroundCell", forIndexPath: indexPath)
            cell.backgroundColor = UIColor.redColor()
            if (cell.backgroundView == nil) {
                cell.backgroundView = UIImageView(frame: CGRectMake(0.0, 0.0, Est.calculatedWidthFromRatio(1242.0), Est.calculatedHeightFromRatio(3568.0)))
                (cell.backgroundView as! UIImageView).image = UIImage(named: "sendcode_bg")
                (cell.backgroundView as! UIImageView).contentMode = .ScaleToFill
            }
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (tableView.isEqual(self.tableView)) {
            if (indexPath.row == 0) {
                return Est.calculatedHeightFromRatio(1225.0)
            } else if (indexPath.row == 1) {
                return Est.calculatedHeightFromRatio(270.0)
            } else if (indexPath.row == 12) {
                return Est.calculatedHeightFromRatio(284.0)
            } else if (indexPath.row == 13) {
                return Est.calculatedHeightFromRatio(146.0)
            } else {
                return Est.calculatedHeightFromRatio(166.0)
            }
        } else {
            return Est.calculatedHeightFromRatio(3586.0)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.backgroundTableView.contentOffset = scrollView.contentOffset
    }
    
    // MARK: - reachability
    
    func setupReachability() {
        do {
            self.reachability = try Reachability(hostname: "www.google.com")
        } catch {
            print("catch setupReachability")
        }
    }
    
    // MARK: - reachability delegate
    
    func reachabilityChanged(note: NSNotification) {
        let reachability = note.object as! Reachability
        if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
            
            EstHTTPService.sharedInstance.getDataInfo(Callback() { (result, success, errorString, error) in
                if (success) {
                }
            })
            
            // TODO: - get daily quota -> calculate dailyquota -> set sendable
            self.checkDailyQuota()
            
            self.getAnnounceRound()
        } else {
            print("Network not reachable")
            self.sendable = false
            self.tableView.reloadData()
        }
    }
    
    override func menuDidTap() {
        let menu = MenuTableViewController(nibName: "MenuTableViewController", bundle: nil)
        menu.modalPresentationStyle = .OverCurrentContext
        menu.currentIndex = 0
        self.definesPresentationContext = true
        self.presentViewController(menu, animated: false, completion: nil)
        
        // MARK: - googleanalytics
        AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "Click_menu")
    }
    
    func checkValidPhoneNumber(phoneNumber: String) -> Bool {
        if (phoneNumber.characters.count == 10) {
            let infix = phoneNumber.substringToIndex(phoneNumber.startIndex.advancedBy(2))
            if (infix == "08" || infix == "06" || infix == "09") {
                self.sendable = true
                return true
            }
        }
        self.sendable = false
        return false
    }
    
    // MARK: - api
    
    func checkDailyQuota() {
        if let phoneData = DataManager.sharedInstance.getObjectForKey("phone_number") {
            EstHTTPService.sharedInstance.checkDailyQuota(phoneData as! String, cb: Callback() { (quota, success, errorString, error) in
                if (success) {
                    self.dailyQuota = quota!
                    self.tableView.reloadData()
                } else {
                    // TODO: ...
                }
            })
        }
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
    
    func presentThankyouPopup() {
        let popup = PopupViewController(nibName: "PopupViewController", bundle: nil)
        popup.modalPresentationStyle = .OverCurrentContext
        popup.initPopup(0)
        self.definesPresentationContext = true
        self.presentViewController(popup, animated: false, completion: nil)
    }
    
}

extension SendCodeTableViewController: UITextFieldDelegate  {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = NSCharacterSet(charactersInString: "0123456789").invertedSet
        let newLength = textField.text!.utf16.count + string.utf16.count - range.length
        if (textField.tag == 99) {
            return (string.rangeOfCharacterFromSet(invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil) && (newLength <= 10)
        } else {
            return (string.rangeOfCharacterFromSet(invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil) && (newLength <= 11)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if (textField.tag == 99) {
            if (self.checkValidPhoneNumber(textField.text!)) {
                print("valid phone number")
                DataManager.sharedInstance.setObjectForKey(textField.text!, key: "phone_number")
                self.phoneNumber = textField.text!
                self.sendable = true
                self.phoneNumberCell?.checkMarkImageView.hidden = false
            } else {
                print("invalid phone number")
                self.sendable = false
                self.phoneNumber = textField.text!
                self.showPopupAlertView("เบอร์โทรศัพท์มือถือไม่ถูกต้อง")
                self.phoneNumberCell?.checkMarkImageView.hidden = true
            }
            self.tableView.reloadData()
        } else {
            self.codes[textField.tag] = textField.text
            self.sendable_codes.removeValueForKey(textField.tag)
            print(self.codes)
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.activeTextField = textField
        if (textField.tag == 99) {
            self.phoneNumber = textField.text!
            self.sendable = false
            self.sendButtonCell?.sendButton.enabled = false
            self.phoneNumberCell?.checkMarkImageView.hidden = true
        }
        print("textfield : \(textField.tag)")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.activeTextField?.resignFirstResponder()
        return true
    }
    
    // MARK: - estpopupalertview
    
    func showPopupAlertView(message: String) {
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

extension SendCodeTableViewController: SendButtonTableViewCellDelegate {
    
    func sendButtonDidTap() {
        
        // MARK: - googleanalytics
        AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "Click_submitCode")
        EstHTTPService.sharedInstance.sendCode()
        
        if (!self.sendable) {
            // TODO: - show error popup ( phone number )
            return
        }
        
        if (self.activeTextField != nil) {
            if (self.activeTextField!.tag == 99) {
                if (self.activeTextField?.text != nil && self.activeTextField!.text?.characters.count == 10) {
                    if (self.checkValidPhoneNumber(self.activeTextField!.text!)) {
                        DataManager.sharedInstance.setObjectForKey(self.activeTextField!.text!, key: "phone_number")
                        self.phoneNumber = self.activeTextField!.text!
                    }
                }
            }
        }
        
        var codes = [String]()
        if (self.codes.count > 0) {
            for (key, value) in self.codes {
                if(value != "")    {
                    codes.append(value)
                } else {
                    self.codes.removeValueForKey(key)
                    self.sendable_codes.removeValueForKey(key)
                }
            }
            
            if (codes.count == 0) {
                print("Alertttt")
                /// show alert text
            } else {
                print("Senddddd Codeeee !")
                print(self.codes)
                if (checkSendableCode()) {
                    self.error = false
                    self.sendCodes(codes)
                    // self.sendCodes(codes)
                    // self.estHTTPService.sendEstPromoCodeTracker("Button", action: "clicked", label: "Click_submitCode")
                } else {
                    // self.alertmessage = true
                    self.error = true
                    self.sendButtonCell?.errorImageView.hidden = false
                }
            }
        } else {
            print("alert !!!!")
            self.codes.removeAll(keepCapacity: false)
            self.error_sendcode.removeAll(keepCapacity: false)
            
            // show alert text
        }
        self.tableView.reloadData()
    }
    
    func checkSendableCode() -> Bool    {
        
        for (key,value) in self.codes   {
            // Check Empty  and check input only one textfield
            if(value == "" || self.codes.count <= 1 )   {
                self.sendable_codes.removeValueForKey(key)
            }
            
            // check length of code
            if(value.characters.count == 11) {
                self.sendable_codes.removeValueForKey(key)
            } else {
                self.sendable_codes[key] = false
            }
            
            // check same code
            if(value.characters.count == 11) {
                for (tag, text) in self.codes {
                    var count = 0
                    for (tag2, text2) in self.codes   {
                        if (text == text2)   {
                            print("code 1: \(tag) \(text), code 2: \(tag2) \(text)")
                            count += 1
                        }
                    }
                    if(count >= 2)   {
                        print("have same code")
                        self.sendable_codes[tag] = false
                    } else {
                        self.sendable_codes.removeValueForKey(key)
                    }
                }
            }
        }
        
        print(self.codes)
        print(self.sendable_codes)
        
        if(self.sendable_codes.count == 0)  {
            return true
        } else {
            return false
        }
    }

    func sendCodes(codes: [String]) {
        if let phoneNumberData = DataManager.sharedInstance.getObjectForKey("phone_number") {
            self.view.addSubview(self.loadingIndicator)
            EstHTTPService.sharedInstance.sendCode(phoneNumberData as! String, codes: codes, cb: Callback() { (responseCodes, success, errorString, error) in
                if (success) {
                    var validation: Bool = true
                    for (index, code) in responseCodes!.enumerate() {
                        switch code.response! {
                            case .IncorrectFormat:
                                validation = false
                                self.error_sendcode[code.code!] = false
                            case .ExistingCode:
                                validation = false
                                self.error_sendcode[code.code!] = false
                            case .Error:
                                validation = false
                                self.error_sendcode[code.code!] = false
                            default:
                                self.error_sendcode[code.code!] = true
                                break
                        }
                        print("index: \(index), code: \(code.code), response: \(code.response?.responseDescription())")
                    }
                    if (validation) {
                        // TODO: - show popup thank
                        self.error = false
                        self.codes.removeAll(keepCapacity: false)
                        self.sendable_codes.removeAll(keepCapacity: false)
                        // self.error_sendcode.removeAll(keepCapacity: false)
                        self.presentThankyouPopup()
                    } else {
                        // TODO: - ...
                        self.error = true
                    }
                    
                    if(self.error_sendcode.count != 0)  {
                        for(text1, sendable) in self.error_sendcode   {
                            for(tag, text2) in self.codes {
                                if(text1 == text2)  {
                                    if(sendable == false)   {
                                        self.sendable_codes[tag] = false
                                    }
                                }
                            }
                        }
                    }
                    
                    self.checkDailyQuota()
                    self.tableView.reloadData()
                } else {
                    // TODO: - show error
                }
                self.loadingIndicator.removeFromSuperview()
            })
        }
    }
    
}
