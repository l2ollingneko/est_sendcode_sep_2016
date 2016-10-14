//
//  AppDelegate.swift
//  est
//
//  Created by warinporn khantithamaporn on 9/19/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        if ((UIScreen.mainScreen().bounds.size.height / UIScreen.mainScreen().bounds.size.width) < 1.5) {
            self.window = UIWindow(frame: CGRectMake(114.0, 32.0, 540.0, 960.0))
            
            let bg = UIImageView(frame: CGRectMake(-114.0, -32.0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
            bg.image = UIImage(named: "ipad_bg")
            bg.backgroundColor = UIColor.blackColor()
            
            self.window?.addSubview(bg)
            self.window?.sendSubviewToBack(bg)
        } else {
            self.window = UIWindow(frame: CGRectMake(0.0, 0.0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
        }
        
        // ControllerManager.sharedInstance.presentSendCode()
        ControllerManager.sharedInstance.presentAnnouncement()
        EstHTTPService.sharedInstance.openApp()
        
        // MARK: - push noti
        
        let userNotificationTypes: UIUserNotificationType = [.Alert, .Badge, .Sound]
        
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        // MARK: - appsflyer
        
        AppsFlyerTracker.sharedTracker().appsFlyerDevKey = "vdVe9UxXnHjhUoKFT2HAnK"
        AppsFlyerTracker.sharedTracker().appleAppID = "1033833972"
        
        // MARK: - parse
        
        Parse.setApplicationId("5wYuflCCq3BDdVDta6A3VeIihJt53UNlZsIYo3Mh", clientKey: "WnmpSdWxDnIwWkNUzsUK2MoOBzh3jLph71S2QmtU")
        
        // MARK: - google/analytics
        
        // Configure tracker from GoogleService-Info.plist.
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai.trackUncaughtExceptions = true  // report uncaught exceptions
        gai.logger.logLevel = GAILogLevel.Error  // remove before app release
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
        AppsFlyerTracker.sharedTracker().trackAppLaunch()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation!.setDeviceTokenFromData(deviceToken)
        installation!.saveInBackground()
    }


}

