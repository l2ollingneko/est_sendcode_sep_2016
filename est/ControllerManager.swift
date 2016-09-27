//
//  ControllerManager.swift
//  est
//
//  Created by warinporn khantithamaporn on 9/19/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import Foundation

class ControllerManager {
    
    static let sharedInstance = ControllerManager()
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    var sendCode: SendCodeTableViewController?
    var checkWinner: CheckWinnerViewController?
    
    private init() {}
    
    // MARK: - menu
    
    func getMenu() -> MenuTableViewController {
        return MenuTableViewController(nibName: "MenuTableViewController", bundle: nil)
    }
    
    func presentMenu() {
        self.appDelegate.window?.rootViewController = self.getMenu()
        self.appDelegate.window?.makeKeyAndVisible()
    }
    
    // MARK: - sendcode
    
    func getSendCode() -> SendCodeTableViewController {
        if (self.sendCode == nil) {
            self.sendCode = SendCodeTableViewController(nibName: "SendCodeTableViewController", bundle: nil)
        }
        return self.sendCode!
    }
    
    func presentSendCode() {
        self.appDelegate.window?.rootViewController = self.getSendCode()
        self.appDelegate.window?.makeKeyAndVisible()
    }
    
    // MARK: - checkwinner
    
    func getCheckWinner() -> CheckWinnerViewController {
        if (self.checkWinner == nil) {
            self.checkWinner = CheckWinnerViewController(nibName: "CheckWinnerViewController", bundle: nil)
        }
        return self.checkWinner!
    }
    
    func presentCheckWinner() {
        self.appDelegate.window?.rootViewController = self.getCheckWinner()
        self.appDelegate.window?.makeKeyAndVisible()
    }
    
    // MARK: - webview
    
    func getWebView(page: EstWebViewPage) -> WebviewViewController {
        var value: String = ""
        switch page {
            case .Rule:
                value = DataManager.sharedInstance.getObjectForKey("page_rule") as! String
            case .HowTo:
                value = DataManager.sharedInstance.getObjectForKey("page_howto") as! String
            case .Tvc:
                value = DataManager.sharedInstance.getObjectForKey("page_tvc") as! String
        }
        
        let webView =  WebviewViewController(nibName: "WebviewViewController", bundle: nil)
        webView.type = page
        webView.presentWebView(value)
        
        return webView
    }
    
    func presentWebView(page: EstWebViewPage) {
        self.appDelegate.window?.rootViewController = self.getWebView(page)
        self.appDelegate.window?.makeKeyAndVisible()
    }
    
}
