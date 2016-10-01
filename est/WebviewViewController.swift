//
//  WebviewViewController.swift
//  est
//
//  Created by warinporn khantithamaporn on 9/25/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit
import WebKit

class WebviewViewController: UIViewController, EstNavigationBarDelegate, UIWebViewDelegate {
    
    var navBar: EstNavigationBar = EstNavigationBar()
    var webView = UIWebView(frame: CGRectMake(0.0, Est.calculatedHeightFromRatio(84.0), Est.calculatedWidthFromRatio(1242.0), Est.calculatedHeightFromRatio(2040.0)))
    
    var type: EstWebViewPage = EstWebViewPage.Rule
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navBar.delegate = self
        
        self.view.backgroundColor = UIColor.clearColor()
        self.view.clipsToBounds = true
        self.webView.backgroundColor = UIColor.clearColor()
        self.webView.clipsToBounds = true
        self.webView.scrollView.clipsToBounds = true
        
        self.webView.scalesPageToFit = true
        self.webView.delegate = self
        
        self.view.addSubview(self.webView)
        self.view.addSubview(self.navBar)
        
        self.webView.scrollView.bounces = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.getAnnounceRound()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.webView.loadHTMLString("", baseURL: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentWebView(url: String) {
        print("webView url: \(url)")
        let requestURL = NSURL(string: url)
        let request = NSURLRequest(URL: requestURL!)
        self.webView.loadRequest(request)
    }
    
    func menuDidTap() {
        
        // stop webview from playing video
        self.webView.loadHTMLString("", baseURL: nil)
        
        let menu = MenuTableViewController(nibName: "MenuTableViewController", bundle: nil)
        menu.modalPresentationStyle = .OverCurrentContext
        
        switch self.type {
        case .Rule:
            menu.currentIndex = 1
        case .HowTo:
            menu.currentIndex = 2
        case .Tvc:
            menu.currentIndex = 3
        default:
            break
        }
        
        self.definesPresentationContext = true
        self.presentViewController(menu, animated: false, completion: nil)
        
        // MARK: - googleanalytics
        AdapterGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "Click_menu")
    }

    func notiDidTap() {
        ControllerManager.sharedInstance.presentCheckWinner()
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
                    // self.navBar.badge.image = UIImage(named: "red_\(Est.sharedInstance.badgeCounter)")
                }
            } else {
                
            }
        })
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        let zoom = self.webView.bounds.size.width / self.webView.scrollView.contentSize.width
        self.webView.scrollView.setZoomScale(zoom, animated: false)
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
