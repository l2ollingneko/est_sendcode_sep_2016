//
//  AnnouncementViewController.swift
//  est
//
//  Created by warinporn khantithamaporn on 10/14/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

class AnnouncementViewController: UIViewController {
    
    var backgroundImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.clearColor()
        self.view.clipsToBounds = true
        
        self.backgroundImageView.frame = Est.calculatedRectFromRatio(0.0, y: 0.0, w: 1242.0, h: 2208.0)
        self.backgroundImageView.image = UIImage(named: "splash")
        
        self.backgroundImageView.backgroundColor = UIColor.clearColor()
        self.backgroundImageView.clipsToBounds = true
        
        self.view.addSubview(self.backgroundImageView)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(5.0), target: self, selector: #selector(AnnouncementViewController.finishAnnounce), userInfo: nil, repeats: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func finishAnnounce() {
        ControllerManager.sharedInstance.presentSendCode()
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
