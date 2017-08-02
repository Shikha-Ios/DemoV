//
//  ImageCategory.swift
//  Vita
//
//  Created by Anurag Yadav on 25/07/17.
//  Copyright © 2017 Mobileprogramming. All rights reserved.
//

import Foundation

extension UIButton {
  func setImageWith(imageName name: String,forState State: UIControlState) {
    self.setImage(UIImage(named:name), for: UIControlState(rawValue: State.rawValue))
  }
  
  func setColorForDefaultState(withColor color: UIColor)  {
    self.setTitleColor(color, for: .normal)
  }
}

extension UIColor {
 public class var vitaDefaultColor:UIColor {
    return UIColor(colorLiteralRed: 70.0/255.0, green: 182.0/255.0, blue: 201.0/255.0, alpha: 1.0)  }
}
