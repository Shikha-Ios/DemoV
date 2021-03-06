//
//  ForgotPasswordViewController.swift
//  Vita
//
//  Created by Shemona.Puri on 24/07/17.
//  Copyright © 2017 Mobileprogramming. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailAddressTextField: UITextField!
    let PasswordViewModel = ForgotPaswordViewModel()
    var passwordApiToken : String?


    override func viewDidLoad() {
        super.viewDidLoad()
        //emailAddressTextField.text = "shemona.puri@mobileprogrammingllc.com"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Action Methods
    @IBAction func sendLinkClicked(sender: UIButton){
        if (!self.checkValidation())
        {
            return
        }
        else
        {
            emailAddressTextField.resignFirstResponder()
            VitaActivityIndicator.showIndicator(containerView: self.view)
            self.callForgotService(email: emailAddressTextField.text!)
        }
    }
    
    @IBAction func privacyClicked(sender: UIButton){
    }
    
    @IBAction func backClicked(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: UITextField Delegates
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Forgot Password API Call
    func callForgotService(email: String) {
       let forgotPassword = ServicePath.forgotPassword(email:emailAddressTextField.text!)
        PasswordViewModel.delegate = self
        PasswordViewModel.apiCallWithType(type: forgotPassword)
    }

    // MARK: - Alert Handler
    func showAlertControllerWithTitle(title: String?, message: String?)
    {
        let appearance = VitaAlertViewController.SCLAppearance(showCloseButton: false)
        let alert = VitaAlertViewController(appearance: appearance)
        alert.addButton("Ok"){
            print("Ok tapped")
            if(message == "Verification code sent to email address")
            {
                self.performSegue(withIdentifier:"VerificationVC", sender: nil)
            }
        }
        alert.showWarning(title!, subTitle: message!)
    }

    //MARK: -  Input Validation Methods/Alert Methods...
    func checkValidation() ->Bool
    {
        
        if (emailAddressTextField.text?.characters.count == 0)
        {
            self.showAlertControllerWithTitle(title: "Alert", message: "Please enter the email id")
            return false
        }

        if ((emailAddressTextField.text?.characters.count)! > 0 && (!self.isValidEmail(email: emailAddressTextField.text as String!)))
        {
            self.showAlertControllerWithTitle(title: "Alert", message: "Please enter the valid email id")
            return false
        }
        
        return true
    }
    
    func isValidEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }

    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "VerificationVC") {
            // pass data to next view
            let viewController: VerificationCodeViewController = (segue.destination as? VerificationCodeViewController)!
            viewController.passwordApiToken = passwordApiToken
            viewController.emailAddress  = emailAddressTextField.text

        }
    }
}

extension ForgotPasswordViewController:BaseModelDelegate {
    func refreshController(model:BaseViewModels?,info:Any?,error:Error?) {
        VitaActivityIndicator.hideIndicator()

        //Refresh the screen over here...
        if(error == nil)
        {
            print("ForgotPassword info\(String(describing: PasswordViewModel.forgotPasswordInfo?.token))")
            passwordApiToken = PasswordViewModel.forgotPasswordInfo?.token
            self.showAlertControllerWithTitle(title: "Alert", message: PasswordViewModel.forgotPasswordInfo?.message )

        }
        else
        {
            print("error is \(String(describing: error))")
            self.showAlertControllerWithTitle(title: "Error", message: error?.localizedDescription )
        }
    }
}
