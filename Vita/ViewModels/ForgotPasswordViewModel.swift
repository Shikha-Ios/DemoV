//
//  ForgotPasswordViewModel.swift
//  Vita
//
//  Created by Shemona.Puri on 27/07/17.
//  Copyright © 2017 Mobileprogramming. All rights reserved.
//


import Foundation

class ForgotPasswordViewModel:BaseViewModels, ViewModelParams {
    
    var forgorPasswordInfo:ForgotPasswordData?
    
    let webAPIWrapper:WebAPIWrapper = WebAPIWrapper()
    
    func apiCallWithType(type:ServicePath) {
        
        let envelop = RegisterEnvelop(pathType: type)
        webAPIWrapper.delegate = self
        webAPIWrapper.callServiceWithRequest(requestEnvelop: envelop)
    }
    
    override func didReceiveResponse(request:Requestable, data:Any?,error:Error?) {
        /* Here developers has to do parsing and return back control to controller */
        guard let responseData = data else {
            self.delegate?.refreshController(model: self, info: data, error: error)
            return
        }
        
        if let result = responseData as? ResponseResult<Any>,
            let resultValue = result.error   {
            self.forgorPasswordInfo = nil
            self.delegate?.refreshController(model: self, info: nil, error: resultValue)
        }
        
        if let result = responseData as? ResponseResult<Any>,
            let resultValue = result.value as? ForgotPasswordData {
            self.forgorPasswordInfo = resultValue
            self.delegate?.refreshController(model: self, info: nil, error: error)
        }
        
    }
}

