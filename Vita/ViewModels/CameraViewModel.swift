//
//  CameraViewModel.swift
//  Vita
//
//  Created by Anurag Yadav on 19/07/17.
//  Copyright © 2017 Mobileprogramming. All rights reserved.
//

import Foundation
import LLSimpleCamera
import Photos

protocol CameraViewModelDelegate {
  func updateUI()
}

class CameraViewModel {
  
  public var imageArray = [UIImage]()
  public var videoArray = [URL]()
  
  fileprivate let manager = PHImageManager.default()
  fileprivate let option = PHImageRequestOptions()
  fileprivate let videoRequestOptions = PHVideoRequestOptions()

  fileprivate var image: UIImage?
  

  static var defaultModel = CameraViewModel()
  var delegate: CameraViewModelDelegate?
		
    
    static let sharedInstance : CameraViewModel = {
        let instance = CameraViewModel()
        return instance
    }()
    
  init() {
    self.option.isSynchronous = true
    self.option.deliveryMode = .highQualityFormat
    self.videoRequestOptions.deliveryMode = .fastFormat
    self.videoRequestOptions.version = .original
    self.videoRequestOptions.isNetworkAccessAllowed = true
  }
  
  func getAssetFromMediaLibrary(asset assets: [PHAsset]) {
    for asset in assets {
      switch asset.mediaType {
      case .image:
        self.getAssetImage(asset: asset)
      case .video:
        self.getVideoURLFromAsset(asset: asset)
      default:
        print("FUNK YOU DUDE, i don't need you")
      }
    }
    delegate?.updateUI()
  }
    
  
    
    
fileprivate func getAssetImage(asset: PHAsset) {
      manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: self.option, resultHandler: {(result, info)->Void in
        self.imageArray.append(result!)
      })
 }
  
  fileprivate func getVideoURLFromAsset(asset: PHAsset) {
     manager.requestAVAsset(forVideo: asset, options: self.videoRequestOptions) { (asset, audioMix, info) in
      let urlAsset = asset as! AVURLAsset
      self.videoArray.append(urlAsset.url)
    }
  }
}
