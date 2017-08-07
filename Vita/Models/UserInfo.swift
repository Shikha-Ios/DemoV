//
//  UserInfo.swift
//  Vita
//
//  Created by Shemona.Puri on 24/07/17.
//  Copyright © 2017 Mobileprogramming. All rights reserved.
//
import Foundation

protocol Identifiable {
    static func parseJSON(data:String,errorStatusCode : Int?)->ResponseResult<Any>?
}

class UserInfo:Identifiable {

    var userId:String?
    var email:String?
    var token:String?

    static func parseJSON(data:String,errorStatusCode : Int?)->ResponseResult<Any>? {
        
        if let responseData = data.convertToDictionary(){
            print("parsed Api response\(responseData)")
            let status : String = (responseData["status"]! as AnyObject).stringValue
            if status != "1"
            {
                print("check error")
                let desc = responseData["error"]
                let err = APIResponseError.generalError(domain: "Parsing Error", description: desc as? String, errorCode:errorStatusCode )
                return .failure(err)
            }
            let userDict = responseData["user"] as! NSDictionary
            let user = UserInfo()
            user.email =  (userDict["email"] as? String)!
            user.userId = (userDict["id"]! as AnyObject).stringValue
            user.token =  responseData["token"] as? String
            return .success(user)
        }
        let err = APIResponseError.generalError(domain: "Parsing Error", description: "Wrong Data Format", errorCode:errorStatusCode )
        return .failure(err)
    }

}
