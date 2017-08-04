//
//  CameraDashboardViewController.swift
//  Vita
//
//  Created by Shemona.Puri on 17/07/17.
//  Copyright © 2017 Mobileprogramming. All rights reserved.
//

import UIKit
import LLSimpleCamera
import Photos
import CTAssetsPickerController

class CameraDashboardViewController: UIViewController {
  
  @IBOutlet weak var cameraOutlet: UIButton!
  @IBOutlet weak var videoOutlet: UIButton!
  @IBOutlet weak var centerXConstraint: NSLayoutConstraint!
  @IBOutlet weak var placeHolderImageView: UIImageView!
  @IBOutlet weak var galleryAccessbutton: UIButton!
  @IBOutlet weak var cameraCapture: MIBadgeButton!
  @IBOutlet weak var mapViewButton: UIButton!
  @IBOutlet weak var dashBoardButton: UIButton!
  @IBOutlet weak var flashButton: UIButton!
  @IBOutlet weak var swipeCamera: UIButton!
  @IBOutlet weak var cameraBottomLayer: UIView!
  
  var flashSelecteion = 0
  //var cameraViewModel : CameraViewModel?
		
    @IBOutlet weak var caneraNext_btn: UIButton!
  var camera = LLSimpleCamera()
  var snapButton: UIButton?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    CameraViewModel.sharedInstance.delegate = self
    self.initializeCamera()
    self.brignSubViewsToFront()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.camera.start()
    if CameraViewModel.sharedInstance.imageArray.count > 0{
        caneraNext_btn.isEnabled = true
        self.cameraCapture.badgeString = "\(CameraViewModel.sharedInstance.imageArray.count)"
    }
    else{
    caneraNext_btn.isEnabled = false
        self.cameraCapture.badgeString = "\(CameraViewModel.sharedInstance.imageArray.count)"
    }
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  // MARK: - Camera Functions
  
  @IBAction func flashButton(_ sender: UIButton) {
    if flashSelecteion == 0 {
      if camera.updateFlashMode(LLCameraFlashOn){
        flashSelecteion = 1
        flashButton.setImageWith(imageName: "Flash_Seleted", forState: UIControlState.normal)
        
      }
    }
    else if flashSelecteion == 1 {
      if camera.updateFlashMode(LLCameraFlashOff){
        flashSelecteion = 2
        flashButton.setImageWith(imageName: "Flash_Unselected", forState: UIControlState.normal)
      }
    }
    else if flashSelecteion == 2 {
      if camera.updateFlashMode(LLCameraFlashAuto){
        flashSelecteion = 0
        flashButton.setImageWith(imageName: "Flash_Auto", forState: UIControlState.normal)
      }
    }
    
  }
  
  
  @IBAction func openGallery(_ sender: Any) {
    PHPhotoLibrary.requestAuthorization({(_ status: PHAuthorizationStatus) -> Void in
      DispatchQueue.main.async(execute: {() -> Void in
        let picker = CTAssetsPickerController()
        picker.delegate = self
        if UI_USER_INTERFACE_IDIOM() == .pad {
          
          picker.modalPresentationStyle = .formSheet
        }
        self.present(picker, animated: true, completion: nil)
      })
    })
    
  }
  
  @IBAction func swipeCamera(_ sender: UIButton) {
    self.camera.togglePosition()
  }
  
  @IBAction func cameraAction(_ sender: Any) {
    self.centerXConstraint.constant = 0
    self.videoOutlet.setColorForDefaultState(withColor: UIColor.white)
    self.cameraOutlet.setColorForDefaultState(withColor: UIColor.vitaDefaultColor)
    UIView.animate(withDuration: 1.0, animations:{
      self.view.layoutIfNeeded()
    })
    
  }
  
  @IBAction func videoAction(_ sender: Any) {
    self.videoOutlet.setColorForDefaultState(withColor: UIColor.vitaDefaultColor)
    self.cameraOutlet.setColorForDefaultState(withColor: UIColor.white)
    self.centerXConstraint.constant = -50-self.videoOutlet.frame.size.width
    UIView.animate(withDuration: 1.0, animations:{
      self.view.layoutIfNeeded()
    })
  }
  @IBAction func capturePhoto(_ sender: UIButton) {
    
    camera.capture {[unowned self] (_ camera: LLSimpleCamera?, _ image: UIImage?, _ metadata: [AnyHashable: Any]?, _ error: Error?)  in
      if error == nil {
        print(image?.size.height ?? 0.0)
        self.camera.start()
        CameraViewModel.sharedInstance.imageArray.append(image!)
        self.cameraCapture.badgeString = "\(CameraViewModel.sharedInstance.imageArray.count)"
        self.caneraNext_btn.isEnabled = true
    
      }
      else {
        print("An error has occured: \(String(describing: error))")
      }
    }
  }
  
  // MARK: - Private Functions
  
  
  
  @IBAction func tapToCallDashBoardViewController(_ sender: UIButton) {
    let viewControllersArray = self.navigationController?.viewControllers
    
    for viewController in viewControllersArray! {
      if viewController .isMember(of: ContainerViewController.self)  {
        let controller = viewController as! ContainerViewController
        controller.moveToPage(sender.tag, animated: true)
      }
    }
  }
  fileprivate func brignSubViewsToFront () {
    view.bringSubview(toFront: mapViewButton!)
    view.bringSubview(toFront: dashBoardButton!)
    view.bringSubview(toFront: flashButton!)
    view.bringSubview(toFront: swipeCamera!)
    view.bringSubview(toFront: cameraBottomLayer!)
    view.bringSubview(toFront: galleryAccessbutton!)
    view.bringSubview(toFront: cameraCapture!)
    view.bringSubview(toFront: placeHolderImageView!)
    view.bringSubview(toFront: videoOutlet!)
    view.bringSubview(toFront: cameraOutlet!)
  }
  
  fileprivate func initializeCamera() {
    let screenRect: CGRect = UIScreen.main.bounds
    camera = LLSimpleCamera(videoEnabled: true)
    camera = LLSimpleCamera(quality: AVCaptureSessionPresetHigh, position: LLCameraPositionRear, videoEnabled: true)
    camera.updateFlashMode(LLCameraFlashAuto)
    camera.attach(to: self, withFrame: CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height))
    placeHolderImageView.isHidden = true
  }
}

extension CameraDashboardViewController: CTAssetsPickerControllerDelegate {
  func assetsPickerController(_ picker: CTAssetsPickerController!, didFinishPickingAssets assets: [Any]!) {
    picker.dismiss(animated: true, completion: nil)
    CameraViewModel.sharedInstance.getAssetFromMediaLibrary(asset: assets as! [PHAsset])
  }
}

extension CameraDashboardViewController: CameraViewModelDelegate {
  func updateUI() {
    self.cameraCapture.badgeString = "\(CameraViewModel.sharedInstance.imageArray.count)"
  }
}
