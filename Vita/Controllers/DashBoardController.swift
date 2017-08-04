//
//  DashBoardController.swift
//  Vita
//
//  Created by Anurag Yadav on 18/07/17.
//  Copyright © 2017 Mobileprogramming. All rights reserved.
//

import Foundation
import UIKit

class DashBoardController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func tapForCameraViewController(_ sender: UIButton) {
    let viewControllersArray = self.navigationController?.viewControllers
    
    for viewController in viewControllersArray! {
      if viewController .isMember(of: ContainerViewController.self)  {
        let controller = viewController as! ContainerViewController
        controller.moveToPage(sender.tag, animated: true)
      }
    }
  }
  
    @IBAction func navigateToMyVitaUpdates(_ sender: UIButton) {
        self.performSegue(withIdentifier:"UpdatesVC", sender: nil)

    
    }
    @IBAction func navigateToAroundMe(_ sender: UIButton) {
        self.performSegue(withIdentifier:"AroundVC", sender: nil)

        
    }
    @IBAction func navigateToHighFives(_ sender: UIButton) {
        self.performSegue(withIdentifier:"HighVC", sender: nil)

        
    }
    @IBAction func navigateToWatchList(_ sender: UIButton) {
        self.performSegue(withIdentifier:"WatchVC", sender: nil)

        
    }
    @IBAction func navigateToFeatured(_ sender: UIButton) {
        self.performSegue(withIdentifier:"FeaturedVC", sender: nil)

    }
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
