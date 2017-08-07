//
//  String+Json.swift
//  WallyPark
//
//  Created by MobileProgramming on 6/5/17.
//  Copyright © 2017 MobileProgramming. All rights reserved.
//

import Foundation
extension String {
    func convertToDictionary() -> [String: Any]? {
        
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func convertToArray() -> [Any]? {
        
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
