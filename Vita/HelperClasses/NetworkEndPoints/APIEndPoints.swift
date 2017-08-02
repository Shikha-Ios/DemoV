//
//  APIEndPoints.swift
//  Vita
//
//  Created by Shemona.Puri on 17/07/17.
//  Copyright © 2017 Mobileprogramming. All rights reserved.
//

import Foundation

protocol ParameterBodyMaker {
    func httpBodyEnvelop()->[String:Any]?
    func encodeBodyEnvelop() throws -> Data?
}

/*
Request Envelops are mentioned here with api path, pathType(Enum with tupple which holds api parameters)
*/
struct LoginEnvelop:Requestable  {
    
    var apiPath:String { return "/api/login" }
    var httpType:HttpType { return .post }
    var pathType : ServicePath
    /* This member property for data model in which data need to be parsed. */
    var modelType:Identifiable.Type? { return UserInfo.self }
}

struct RegisterEnvelop:Requestable  {
    var apiPath:String { return "/api/register" }
    var httpType:HttpType { return .post }
    var pathType : ServicePath 
    /* */
    var modelType:Identifiable.Type? { return RegisterUserData.self }
}

struct ForgotPasswordEnvelop:Requestable  {
    var apiPath:String { return "/api/forgotpassword" }
    var httpType:HttpType { return .post }
    var pathType : ServicePath
    /* */
    var modelType:Identifiable.Type? { return ForgotPasswordData.self }
}
struct ResetPasswordEnvelop:Requestable  {
    var apiPath:String { return "/api/resetpassword" }
    var httpType:HttpType { return .post }
    var pathType : ServicePath
    /* */
    var modelType:Identifiable.Type? { return ResetPasswordData.self }
}


/*
 ALL services post dictionary is mentioned under enum switch statement.
 These cases get their values in ViewController (or respective controller or other class).
 This enum also wrap a method which provides dictionary for post body.
*/
internal enum ServicePath:ParameterBodyMaker {
    case login(email:String, password:String, device_token:String)
    case registration(email:String, password:String, device_id:String,device_type:String,authentication_type:String,facebook_id:String,guid:String,device_token:String)
    case forgotPassword(email:String)
    case resetPassword(email:String, verification_code:String, password:String,confirm_password:String,token:String)

    
    func httpBodyEnvelop()->[String:Any]? {
        
        switch self {
        case .login(email: let email, password: let pwd, device_token: let device_token):

            let postBody = ["email":email, "password":pwd, "device_token":device_token]
            return postBody
            
          
        case .registration(email:let email, password:let password, device_id:let device_id,device_type:let device_type,authentication_type:let authentication_type,facebook_id:let facebook_id,guid:let guid,device_token: let device_token):
            
        let postBody = ["email":email,"password":password,"device_id":device_id,"device_type":device_type,"authentication_type":authentication_type,"facebook_id":facebook_id,"guid":guid,"device_token":device_token]
            return postBody
        
        case .forgotPassword(email: let email):
        let postBody = ["email":email]
        return postBody


        case .resetPassword(email:let email, verification_code:let verification_code, password:let password,confirm_password:let confirm_password,token:let token):
            
            let postBody = ["email":email,"verification_code":verification_code,"password":password,"confirm_password":confirm_password,"token":token]
            return postBody
        
        }
        

    }
    
    func encodeBodyEnvelop() throws -> Data? {
        
        do {
            if let body = self.httpBodyEnvelop() {
            let data = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                return data
            }
        }
        catch  {
            throw error
        }
        
        return nil
    }
}

struct APIEndPoints {
    
}
