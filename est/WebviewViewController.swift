//
//  WebviewViewController.swift
//  est
//
//  Created by warinporn khantithamaporn on 9/25/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

class WebviewViewController: UIViewController, EstNavigationBarDelegate {
    
    var navBar: EstNavigationBar = EstNavigationBar()
    var webView = UIWebView(frame: CGRectMake(0.0, Est.calculatedHeightFromRatio(168.0), Est.calculatedWidthFromRatio(1242.0), Est.calculatedHeightFromRatio(2208.0)))
    
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
        
        self.webView.scrollView.frame = self.webView.frame
        
        self.view.addSubview(self.webView)
        self.view.addSubview(self.navBar)
        
        self.webView.scrollView.bounces = false
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
