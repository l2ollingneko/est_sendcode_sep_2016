//
//  Callback.swift
//  est
//
//  Created by warinporn khantithamaporn on 9/19/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import Foundation

class Callback<T> {
    
    var callback: (T?, Bool, String?, NSError?) -> Void
    
    required init(callback: (T?, Bool, String?, NSError?) -> Void) {
        self.callback = callback
    }
    
}
