//
//  RegisterUserData.swift
//  Vita
//
//  Created by Shemona.Puri on 24/07/17.
//  Copyright © 2017 Mobileprogramming. All rights reserved.
//


import Foundation

class RegisterUserData:Identifiable {
    
    var userId:String?
    var email:String?
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
                let userDict = responseData["data"] as! NSDictionary
                let user = RegisterUserData()
                user.email =  (userDict["email"] as? String)!
                user.userId = (userDict["id"]! as AnyObject).stringValue
                user.token =  responseData["token"] as? String
                return .success(user)
        }
        let err = APIResponseError.generalError(domain: "Parsing Error", description: "Wrong Data Format", errorCode:111)
        return .failure(err)
    }
}
