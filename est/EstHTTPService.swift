//
//  EstHTTPService.swift
//  est
//
//  Created by warinporn khantithamaporn on 9/20/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class EstHTTPService {
    
    static let sharedInstance = EstHTTPService()
    
    private let BASE_API_URL = "http://www.estcolathai.com/promotion/api/mobile/"
    
    private static let APP_DATA_KEY = [
        "appname",
        "show_at_home",
        "active",
        "youtube",
        "share_url",
        "share_title",
        "share_description",
        "share_image",
        "shareresult_url",
        "shareresult_title",
        "shareresult_description",
        "shareresult_image",
        "sharewinner_url",
        "sharewinner_title",
        "sharewinner_description",
        "sharewinner_image",
        "sharenotwin_url",
        "sharenotwin_title",
        "sharenotwin_description",
        "sharenotwin_image",
        "page_tvc",
        "page_rule",
        "page_howto",
        "api_stat",
        "api_sendCode",
        "api_checkQuota",
        "api_checkWinner",
        "api_alertData",
        "api_winnerAnnounce",
        "api_saveShareToWall"
    ]
    
    private init() {}
    
    func getDataInfo(cb: Callback<Bool>) {
        let url = self.BASE_API_URL + "mobileapp_getDataInfo.aspx"
        Alamofire.request(.GET, url).responseJSON { response in
            if let data: AnyObject = response.result.value {
                let json = JSON(data)
                for appData in json["appdata"].array! {
                    for key in EstHTTPService.APP_DATA_KEY {
                        DataManager.sharedInstance.setObjectForKey(appData[key].string, key: key)
                    }
                }
                cb.callback(true, true, nil, nil)
            } else {
                cb.callback(nil, false, nil, nil)
            }
        }
    }
    
    func sendCode(mobileno: String, codes: [String], cb: Callback<[Code]>) {
        let url = self.BASE_API_URL + "mobileapp_sendcode.aspx"
        var parameters = Dictionary<String, AnyObject>()
        
        parameters["mobileno"] = mobileno
        parameters["caller"] = "json"
        
        var resultCodes = ""
        for code in codes {
            resultCodes += "\(code)|"
        }
        
        resultCodes.removeAtIndex(resultCodes.endIndex.predecessor())
        parameters["code"] = resultCodes
        
        for (key, value) in parameters {
            print("key: \(key), value: \(value)")
        }
        
        Alamofire.request(.POST, url, parameters: parameters).responseJSON { response in
            if let data: AnyObject = response.result.value {
                var json = JSON(data)
                print(json["result"].string)
                if (json["result"].string == "complete") {
                    var codes = [Code]()
                    for responseCode in json["codelist"].array! {
                        codes.append(Code.getCode(responseCode))
                    }
                    cb.callback(codes, true, nil, nil)
                } else {
                    print("can't send code: exit a")
                    cb.callback(nil, false, nil, nil)
                }
            } else {
                print("can't send code: exit b, \(response.result.error?.localizedDescription)")
                cb.callback(nil, false, nil, response.result.error)
            }
        }
    }
    
    func checkWinnerAnnounce(cb: Callback<[JSON]>) {
        let url = self.BASE_API_URL + "mobileapp_getWinnerAnnounce.aspx"
        
        Alamofire.request(.GET, url).responseJSON { response in
            if let data: AnyObject = response.result.value {
                let json = JSON(data)
                print(json)
                var jsons = [JSON]()
                for j in json["data"].array! {
                    jsons.append(j)
                }
                cb.callback(jsons, true, nil, nil)
            } else {
                cb.callback(nil, false, nil, response.result.error)
            }
        }
    }
    
    func checkWinner(mobileno: String, cb: Callback<JSON>) {
        let url = self.BASE_API_URL + "mobileapp_checkwinner.aspx"
        
        var parameters = Dictionary<String, AnyObject>()
        parameters["mobileno"] = mobileno
        
        Alamofire.request(.POST, url, parameters: parameters).responseJSON { response in
            if let data: AnyObject = response.result.value {
                let json = JSON(data)
                print(json)
                if (json["result"].string == "winner") {
                    cb.callback(json, true, "winner", nil)
                } else if (json["result"].string == "notwinner") {
                    cb.callback(json, true, "notwinner", nil)
                } else if (json["result"].string == "waitingtime") {
                    cb.callback(json, true, "waitingtime", nil)
                } else {
                    cb.callback(nil, false, nil, nil)
                }
            } else {
                cb.callback(nil, false, nil, response.result.error)
            }
        }
    }
    
    func checkDailyQuota(mobileno: String, cb: Callback<Int>) {
        let url = self.BASE_API_URL + "mobileapp_checkdailyquota.aspx"
        
        var parameters = Dictionary<String, AnyObject>()
        parameters["mobileno"] = mobileno
        
        Alamofire.request(.POST, url, parameters: parameters).responseJSON { response in
            if let data: AnyObject = response.result.value {
                let json = JSON(data)
                if (json["result"].string == "complete") {
                    let quota = Int(json["detail"].string!)
                    cb.callback(quota, true, nil, nil)
                } else {
                    cb.callback(nil, false, nil, nil)
                }
            } else {
                cb.callback(nil, false, nil, nil)
            }
        }
    }
    
    func getAnnounceRound(cb: Callback<Int>) {
        let url = self.BASE_API_URL + "mobileapp_alertData.aspx"
        
        Alamofire.request(.GET, url).responseJSON { response in
            if let data: AnyObject = response.result.value {
                let json = JSON(data)
                print(json)
                if let result = json["result"].string where result == "complete" {
                    if let round = json["detail"].string {
                        Est.sharedInstance.badgeCounter = Int(round)!
                        print("round: \(Est.sharedInstance.badgeCounter)")
                        cb.callback(Int(round), true, nil, nil)
                    } else {
                        cb.callback(nil, false, nil, nil)
                    }
                } else {
                    cb.callback(nil, false, nil, nil)
                }
            } else {
                cb.callback(nil, false, nil, response.result.error)
            }
        }
        
    }
    
    // MARK: - stat
    
    func openApp() {
        var url: String = "http://www.estcolathai.com/promotion/api/mobile/applicationstatlog.aspx"
        if let api_stat = DataManager.sharedInstance.getObjectForKey("api_stat") as? String {
            url = api_stat
        }
        var parameters = Dictionary<String, AnyObject>()
        parameters["stat"] = "estcolapromo"
        parameters["param1"] = "ios"
        parameters["param2"] = "openapp"
        Alamofire.request(.GET, url, parameters: parameters)
    }
    
    func sendCode() {
        var url: String = "http://www.estcolathai.com/promotion/api/mobile/applicationstatlog.aspx"
        if let api_stat = DataManager.sharedInstance.getObjectForKey("api_stat") as? String {
            url = api_stat
        }
        var parameters = Dictionary<String, AnyObject>()
        parameters["stat"] = "estcolapromo"
        parameters["param1"] = "ios"
        parameters["param2"] = "startsendcode"
        Alamofire.request(.GET, url, parameters: parameters)
    }
    
    func saveFBShareForWinner(postId: String) {
        var url: String = "http://www.estcolathai.com/promotion/api/mobile/applicationstatlog.aspx"
        if let api_stat = DataManager.sharedInstance.getObjectForKey("api_stat") as? String {
            url = api_stat
        }
        var parameters = Dictionary<String, AnyObject>()
        parameters["stat"] = "estcolapromo"
        parameters["param1"] = "ios"
        parameters["param2"] = "shareFBWinner"
        parameters["t"] = DataManager.sharedInstance.getObjectForKey("phone_number")
        parameters["post_id"] = postId
        Alamofire.request(.GET, url, parameters: parameters)
    }
    
}
