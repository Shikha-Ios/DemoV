//
//  RegistrationViewModel.swift
//  TemplateProject
//
//  Created by Vishal Lohia on 6/3/17.
//  Copyright © 2017 Mobileprogramming. All rights reserved.
//

import Foundation

class RegistrationViewModel:BaseViewModels, ViewModelParams {
    
    var regUserInfo:RegisterUserData?

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
            self.regUserInfo = nil
            self.delegate?.refreshController(model: self, info: "Registration", error: resultValue)
        }
        
        if let result = responseData as? ResponseResult<Any>,
            let resultValue = result.value as? RegisterUserData {
            self.regUserInfo = resultValue
            self.delegate?.refreshController(model: self, info: "Registration", error: error)
        }
        
    }
}
