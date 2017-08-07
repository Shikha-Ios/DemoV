//
//  ForgotPasswordData.swift
//  Vita
//
//  Created by Shemona.Puri on 27/07/17.
//  Copyright © 2017 Mobileprogramming. All rights reserved.
//

import Foundation

class ForgotPasswordData:Identifiable {
    
    var token:String?
    var message:String?

    static func parseJSON(data:String,errorStatusCode : Int?)->ResponseResult<Any>? {
        if let responseData = data.convertToDictionary(){
            print("parsed Api response\(responseData)")
            let status : String = (responseData["status"]! as AnyObject).stringValue
            if status != "1"
            {
                print("check error")
                let desc = responseData["error"]
                let err = APIResponseError.generalError(domain: "Parsing Error", description: desc as? String, errorCode:errorStatusCode)
                return .failure(err)
            }
            let obj_passwordData = ForgotPasswordData()
            obj_passwordData.token =  responseData["token"] as? String
            obj_passwordData.message = responseData["message"] as? String
            return .success(obj_passwordData)
        }
        let err = APIResponseError.generalError(domain: "Parsing Error", description: "Wrong Data Format", errorCode:errorStatusCode)
        return .failure(err)
    }
}
