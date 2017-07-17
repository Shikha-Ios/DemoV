//
//  ErrorManager.swift
//  Vita
//
//  Created by Shemona.Puri on 17/07/17.
//  Copyright © 2017 Mobileprogramming. All rights reserved.
//

import Foundation

enum APIResponseError:Error {
    case generalError(domain:String?,description:String?,errorCode:Int?)
}

extension APIResponseError : LocalizedError {
    var errorDescription: String? {
        switch self {
        case .generalError(domain: _, description:let desc, errorCode: _):
            return desc!
        }
    }
}

extension APIResponseError:CustomStringConvertible {

    var description: String {
        switch self {
        case .generalError(domain: _, description:let desc, errorCode: _):
            return desc!
        }
    }
}
