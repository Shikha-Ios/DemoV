//
//  ResetPasswordData.swift
//  Vita
//
//  Created by Shemona.Puri on 28/07/17.
//  Copyright © 2017 Mobileprogramming. All rights reserved.
//



import Foundation

class ResetPasswordData:Identifiable {
    
    var token:String?
    
    static func parseJSON(data:Any?)->ResponseResult<Any>? {
        if let responseData = data as? [String : AnyObject] {
            print("value is\(responseData)")
            let status : String = (responseData["status"]! as AnyObject).stringValue
            if status != "1"
            {
                print("check error")
                let desc = responseData["error"]
                let err = APIResponseError.generalError(domain: "Parsing Error", description: desc as? String, errorCode:111)
                return .failure(err)
            }
            let obj_passwordData = ResetPasswordData()
            obj_passwordData.token =  responseData["token"] as? String
            return .success(obj_passwordData)
        }
        let err = APIResponseError.generalError(domain: "Parsing Error", description: "Wrong Data Format", errorCode:111)
        return .failure(err)
    }
}
