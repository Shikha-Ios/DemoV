//
//  NavigationBar.swift
//  Vita
//
//  Created by Anurag Yadav on 20/07/17.
//  Copyright © 2017 Mobileprogramming. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem {

 public var color: UIColor {
    return self.color
  }
  
  public var size: CGSize {
    return self.size
  }
  
  func color(color: UIColor) {
    self.tintColor = color
  }
		
 class func setBarButton(withImage image: UIImage, style: UIBarButtonItemStyle, target: Any?, action: Selector?) -> UIBarButtonItem {
  // let imageToScale = scaleTo(image: image, w: self.size.width, h: self.size.height)
    let leftBarButton = UIBarButtonItem(image: image, style: style, target: self, action: nil)
  //  leftBarButton.tintColor = self.color
    return leftBarButton

  }
  
//  func setRightBarButton(withImage image: UIImage, style: UIBarButtonItemStyle, target: Any?, action: Selector?) -> UIBarButtonItem {
//    let imageToScale = scaleTo(image: image, w: 22, h: 22)
//    let leftBarButton = UIBarButtonItem(image: imageToScale, style: style, target: self, action: nil)
//    leftBarButton.tintColor = self.color
//    return leftBarButton
//  }
  
  private func scaleTo(image: UIImage, w: CGFloat, h: CGFloat) -> UIImage {
    let newSize = CGSize(width: w, height: h)
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
    image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
    let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return newImage
  }
}
