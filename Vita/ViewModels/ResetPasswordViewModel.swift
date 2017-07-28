//
//  ResetPasswordViewModel.swift
//  Vita
//
//  Created by Shemona.Puri on 28/07/17.
//  Copyright © 2017 Mobileprogramming. All rights reserved.
//



import Foundation


class ResetPasswordViewModel:BaseViewModels, ViewModelParams {
    
    var resetPasswordInfo:ResetPasswordData?
    
    let webAPIWrapper:WebAPIWrapper = WebAPIWrapper()
    
    func apiCallWithType(type:ServicePath) {
        
        let envelop = ResetPasswordEnvelop(pathType: type)
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
            self.resetPasswordInfo = nil
            self.delegate?.refreshController(model: self, info: nil, error: resultValue)
        }
        
        if let result = responseData as? ResponseResult<Any>,
            let resultValue = result.value as? ResetPasswordData {
            self.resetPasswordInfo = resultValue
            self.delegate?.refreshController(model: self, info: nil, error: error)
        }
        
    }
    
}
