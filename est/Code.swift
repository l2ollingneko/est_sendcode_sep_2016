//
//  Code.swift
//  est
//
//  Created by warinporn khantithamaporn on 9/25/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import Foundation
import SwiftyJSON

enum CodeResponse {
    case Valid, IncorrectFormat, ExistingCode, Error
    func responseDescription() -> String {
        switch self {
            case .Valid:
                return "Valid"
            case .IncorrectFormat:
                return "IncorrectFormat"
            case .ExistingCode:
                return "ExistingCode"
            default:
                return "Error"
        }
    }
}

class Code {

    var code: String?
    var response: CodeResponse?
    
    init(code: String, response: CodeResponse) {
        self.code = code
        self.response = response
    }
    
    class func getCode(json: JSON) -> Code {
        let code = json["code"].string != nil ? json["code"].string! : ""
        var codeResponse: CodeResponse!
        
        if let responseText = json["text"].string {
            switch responseText {
                case "VALID":
                    codeResponse = .Valid
                case "INCORRECT_FORMAT":
                    codeResponse = .IncorrectFormat
                case "EXISTING_CODE":
                    codeResponse = .ExistingCode
                default:
                    codeResponse = .Error
            }
        } else {
            codeResponse = .Error
        }
        
        return Code(code: code, response: codeResponse)
    }
    
}
