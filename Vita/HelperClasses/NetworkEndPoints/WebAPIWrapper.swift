//
//  WebAPIWrapper.swift
//  Vita
//
//  Created by Shemona.Puri on 17/07/17.
//  Copyright © 2017 Mobileprogramming. All rights reserved.
//

import Foundation
import Alamofire

protocol WebApiWrapperDelegate:class {
    func didReceiveResponse(request:Requestable, data:Any?,error:Error?)
}

class WebAPIWrapper {
    var delegate:WebApiWrapperDelegate?
    
    
    func callServiceWithRequest(requestEnvelop:Requestable) {
        let method = requestEnvelop.httpType.rawValue
        let type = HTTPMethod(rawValue: method)
        
        Alamofire.request(
            requestEnvelop.requestURL()!,
            method: type!,
            parameters: requestEnvelop.pathType.httpBodyEnvelop(),
            encoding:JSONEncoding.default,
            headers: requestEnvelop.httpHeaders())
            .responseString { (response) -> Void in
                print("api response\(response)")
                if let cls = requestEnvelop.modelType  {
                    if(response.result.isSuccess) {
                        print("Response Recieved\(String(describing: response.value))")
                        guard let responseString = response.value else {
                            self.delegate?.didReceiveResponse(request:requestEnvelop , data: response.data, error: response.result.error)
                            return
                        }
                        
                        let status = response.response?.statusCode
                        let results = cls.parseJSON(data: responseString, errorStatusCode: status)
                        
                        self.delegate?.didReceiveResponse(request:requestEnvelop , data: results, error: response.result.error)
                        return
                    }
                }
                self.delegate?.didReceiveResponse(request:requestEnvelop , data: response.data, error: response.result.error)
        }
    }

}

