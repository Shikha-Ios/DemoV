//
//  PHAssetCategory.swift
//  Vita
//
//  Created by Anurag Yadav on 26/07/17.
//  Copyright © 2017 Mobileprogramming. All rights reserved.
//

import Foundation
import Photos

extension PHImageManager {
  func ctassetsPickerRequestImage(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode, options: PHImageRequestOptions, resultHandler: @escaping (_ result: UIImage, _ info: [AnyHashable: Any]) -> Void) -> PHImageRequestID {
    return requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options, resultHandler: resultHandler as! (UIImage?, [AnyHashable : Any]?) -> Void)
  }
}


