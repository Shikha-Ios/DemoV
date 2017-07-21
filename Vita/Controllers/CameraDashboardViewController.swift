//
//  CameraDashboardViewController.swift
//  Vita
//
//  Created by Shemona.Puri on 17/07/17.
//  Copyright © 2017 Mobileprogramming. All rights reserved.
//

import UIKit
import LLSimpleCamera


class CameraDashboardViewController: UIViewController {
  @IBOutlet weak var placeHolderImageView: UIImageView!
  
  @IBOutlet weak var galleryAccessbutton: UIButton!
  @IBOutlet weak var cameraCapture: MIBadgeButton!
  @IBOutlet weak var mapViewButton: UIButton!
  @IBOutlet weak var dashBoardButton: UIButton!
  @IBOutlet weak var flashButton: UIButton!
  @IBOutlet weak var swipeCamera: UIButton!
  
  var arrayImages = [UIImage]()
		
  
  @IBOutlet weak var cameraBottomLayer: UIView!
  var camera = LLSimpleCamera()
  var snapButton: UIButton?

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initializeCamera()
    self.brignSubViewsToFront()
    
  }
  
   override func viewWillAppear(_ animated: Bool) {
    self.camera.start()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
 
  
  // MARK: - Camera Functions
  
  @IBAction func flashButton(_ sender: UIButton) {
    if camera.flash == LLCameraFlashOff {
      let done: Bool = camera.updateFlashMode(LLCameraFlashOn)
      if done {
        flashButton.isSelected = true
        //flashButton.backgroundColor = UIColor.yellow
      }
    }
    else {
      let done: Bool = camera.updateFlashMode(LLCameraFlashOff)
      if done {
        flashButton.isSelected = false
        //flashButton.backgroundColor = UIColor.white
      }
    }
  }
  
  
  
  @IBAction func swipeCamera(_ sender: UIButton) {
    self.camera.togglePosition()
  }
  
  @IBAction func capturePhoto(_ sender: UIButton) {
    
    camera.capture {[unowned self] (_ camera: LLSimpleCamera?, _ image: UIImage?, _ metadata: [AnyHashable: Any]?, _ error: Error?)  in
      if error == nil {
        print(image?.size.height ?? 0.0)
        self.camera.start()
        self.arrayImages.append(image!)
        self.cameraCapture.badgeString = "\(self.arrayImages.count)"
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
  }
  
  fileprivate func initializeCamera() {
    let screenRect: CGRect = UIScreen.main.bounds
    camera = LLSimpleCamera(videoEnabled: true)
    camera = LLSimpleCamera(quality: AVCaptureSessionPresetHigh, position: LLCameraPositionRear, videoEnabled: true)
    camera.attach(to: self, withFrame: CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height))
    placeHolderImageView.isHidden = true
   
  }
  
}
