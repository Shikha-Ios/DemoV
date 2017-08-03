//
//  ContainerViewController.swift
//  Vita
//
//  Created by Anurag Yadav on 18/07/17.
//  Copyright © 2017 Mobileprogramming. All rights reserved.
//

import UIKit

class ContainerViewController: AYSwipeController {
    override func setupView() {
      datasource = self
  }
  override func viewWillAppear(_ animated: Bool) {
  
  }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
      
      //signInNavigationIdentifier
      if AppDelegate.sharedDelegate().isUserLoggedIn {
        let initalViewController: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signInNavigationIdentifier") as! UINavigationController
        self.navigationController?.present(initalViewController, animated: false, completion: nil)
        
      }
  }
  
  class func movePageAtIndex(index: Int){
    self.movePageAtIndex(index: index)
  }
}

extension ContainerViewController: AYSwipeControllerDataSource {

    func viewControllerData() -> [UIViewController] {
      let dashBoard: DashBoardController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashBoardControllerIdentifier") as UIViewController as! DashBoardController
      
        let mapViewController: MapViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewControllerIdentifier") as UIViewController as! MapViewController
      
        let camera: CameraDashboardViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cameraIde") as UIViewController as! CameraDashboardViewController

        return [dashBoard,camera,mapViewController]
    }
  
  func indexOfStartingPage() -> Int {
    return 1
  }
  
}
