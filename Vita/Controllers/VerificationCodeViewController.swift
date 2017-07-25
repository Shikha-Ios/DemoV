//
//  VerificationCodeViewController.swift
//  Vita
//
//  Created by Shemona.Puri on 24/07/17.
//  Copyright © 2017 Mobileprogramming. All rights reserved.
//

import UIKit

class VerificationCodeViewController: UIViewController {
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var verificationCodeTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var retypePasswordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Action Methods
    @IBAction func privacyClicked(sender: UIButton){
        
    }

    @IBAction func signInClicked(sender: UIButton){
    self.performSegue(withIdentifier:"ContainerVC", sender: nil)
    }
    @IBAction func backClicked(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
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
