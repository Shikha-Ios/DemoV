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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
    }
}

extension ContainerViewController: AYSwipeControllerDataSource {
    
    func viewControllerData() -> [UIViewController] {
      let dashBoard: DashBoardController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashBoardControllerIdentifier") as UIViewController as! DashBoardController
      
        let mapViewController: MapViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewControllerIdentifier") as UIViewController as! MapViewController
      
        let camera: CameraDashboardViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cameraIde") as UIViewController as! CameraDashboardViewController

        return [dashBoard,camera,mapViewController]
    }
  
    func changedToPageIndex(_ index: Int) {
        print("Page has changed to: \(index)")
    }
    
    func moveToEnd() {
        self.moveToPage(2, animated: true)
    }
  func indexOfStartingPage() -> Int {
    return 1
  }
    
    func alert(title: String?, message: String, action: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: action, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
