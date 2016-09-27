//
//  Est.swift
//  est
//
//  Created by warinporn khantithamaporn on 9/20/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import Foundation
import SwiftHEXColors

class Est {
    
    static let isiPadSize: Bool = UIScreen.mainScreen().bounds.size.height / UIScreen.mainScreen().bounds.size.width < 1.5
    
    static let dWidth: CGFloat = 1242.0
    static let dHeight: CGFloat = 2208.0
    
    static let rWidth: CGFloat = isiPadSize ? 540.0 : UIScreen.mainScreen().bounds.size.width
    static let rHeight: CGFloat = isiPadSize ? 960.0 : UIScreen.mainScreen().bounds.size.height
    
    static let dNavigationBarSize: CGSize = CGSizeMake(Est.rWidth, 168.0)
    static let dTabBarSize: CGSize = CGSizeMake(Est.rWidth, 160.0)
    
    static let navigationBarHeight: CGFloat = (Est.dNavigationBarSize.height / Est.dHeight) * Est.rHeight
    static let tabBarHeight: CGFloat = (Est.dTabBarSize.height / Est.dHeight) * Est.rHeight
    
    static let DBHELVETHAICA_X_REGULAR: String = "DBHelvethaicaX-55Regular"
    static let DBHELVETHAICA_X_REGULAR_ITALIC: String = "DBHelvethaicaX-56Italic"
    static let DBHELVETHAICA_X_MEDIUM: String = "DBHelvethaicaX-65Med"
    static let DBHELVETHAICA_X_MEDIUM_ITALIC: String = "DBHelvethaicaX-66MedIt"
    static let DBHELVETHAICA_X_BOLD: String = "DBHelvethaicaX-75Bd"
    static let DBHELVETHAICA_X_BOLD_ITALIC: String = "DBHelvethaicaX-76BdIt"
    
    static let EST_BLACK = UIColor(hexString: "#373737")
    static let EST_YELLOW = UIColor(hexString: "#fce029")
    
    private init() {}
    
    class func calculatedWidthFromRatio(width: CGFloat) -> CGFloat {
        return (width / Est.dWidth) * Est.rWidth
    }
    
    class func calculatedHeightFromRatio(height: CGFloat) -> CGFloat {
        return (height / Est.dHeight) * Est.rHeight
    }
    
    class func calculatedRectFromRatio(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) -> CGRect {
        return CGRectMake(Est.calculatedWidthFromRatio(x), Est.calculatedHeightFromRatio(y), Est.calculatedWidthFromRatio(w), Est.calculatedHeightFromRatio(h))
    }
    
}
