//
//  LoginViewController.swift
//  Vita
//
//  Created by Shemona.Puri on 17/07/17.
//  Copyright © 2017 Mobileprogramming. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Action Methods
    @IBAction func backClicked(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signInClicked(sender: UIButton){
        //self.performSegue(withIdentifier:"ContainerVC", sender: nil)
        if (!self.checkValidation())
        {
            return
        }
        else
        {
            self.performSegue(withIdentifier:"ContainerVC", sender: nil)
        }

    }
    @IBAction func facebookSignInClicked(sender: UIButton){
    }
    
    @IBAction func googlePlusSignInClicked(sender: UIButton){
    }
    
    @IBAction func privacyClicked(sender: UIButton){
    }
    
    @IBAction func forgotPasswordClicked(sender: UIButton){
    }
    
    // MARK: UITextField Delegates
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }

    //MARK: -  Input Validation Methods/Alert Methods...
    func checkValidation() ->Bool
    {
        if (userNameTextField.text?.characters.count == 0 && passwordTextField.text?.characters.count == 0)
        {
            self.showAlertControllerWithTitle(title: "Alert", message: "Please enter the information")
            return false
        }
        if (userNameTextField.text?.characters.count == 0)
        {
            self.showAlertControllerWithTitle(title: "Alert", message: "Please enter the valid email id")
            return false
        }
        if (passwordTextField.text?.characters.count == 0)
        {
            self.showAlertControllerWithTitle(title: "Alert", message: "Please enter a valid password")
            return false
        }
        if ((userNameTextField.text?.characters.count)! > 0 && (!self.isValidEmail(email: userNameTextField.text as String!)))
        {
            self.showAlertControllerWithTitle(title: "Alert", message: "Please enter the valid email id")
            return false
        }
        
        return true
    }
    
    func isValidPassword(password: String) -> Bool {
        //Minimum 6 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character:
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{6,}"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
    
    func isValidEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }

    // MARK: - Alert Handler
    func showAlertControllerWithTitle(title: String?, message: String?)
    {
        let appearance = VitaAlertViewController.SCLAppearance(showCloseButton: false)
        let alert = VitaAlertViewController(appearance: appearance)
        alert.addButton("Ok"){
            print("Ok tapped")
        }
        alert.showWarning(title!, subTitle: message!)
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
