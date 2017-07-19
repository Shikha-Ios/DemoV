//
//  InitialViewController.swift
//  Vita
//
//  Created by Shemona.Puri on 17/07/17.
//  Copyright © 2017 Mobileprogramming. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Action Methods
    @IBAction func signInClicked(sender: UIButton){
    self.performSegue(withIdentifier:"LoginVC", sender: nil)
    }
    
    @IBAction func signUpClicked(sender: UIButton){
    self.performSegue(withIdentifier:"RegisterVC", sender: nil)
    }
    
    @IBAction func privacyClicked(sender: UIButton){
    }

    @IBAction func guestClicked(sender: UIButton){
        self.performSegue(withIdentifier:"ContainerVC", sender: nil)
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
