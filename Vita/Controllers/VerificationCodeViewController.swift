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

    var passwordApiToken : String?
    var emailAddress : String?

    let resetPasswordViewModel = ResetPasswordViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("pass\(String(describing: passwordApiToken))")
        emailAddressTextField.isUserInteractionEnabled = false
        emailAddressTextField.text = emailAddress
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Action Methods
    @IBAction func privacyClicked(sender: UIButton){
        
    }

    @IBAction func signInClicked(sender: UIButton){
        if (!self.checkValidation())
        {
            return
        }
        else
        {
            self.resignTextFields()
            VitaActivityIndicator.showIndicator(containerView: self.view)
            self.callResetPasswordService(email: emailAddressTextField.text!, verification_code: verificationCodeTextField.text!, password: newPasswordTextField.text!, confirm_password: retypePasswordTextField.text!, token: passwordApiToken!)
        }
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
    
    //MARK: -  Input Validation Methods/Alert Methods...
    func checkValidation() ->Bool
    {
        if (verificationCodeTextField.text?.characters.count == 0 && newPasswordTextField.text?.characters.count == 0 && retypePasswordTextField.text?.characters.count == 0 )
        {
            self.showAlertControllerWithTitle(title: "Alert", message: "Please enter the information")
            return false
        }
        if (verificationCodeTextField.text?.characters.count == 0)
        {
            self.showAlertControllerWithTitle(title: "Alert", message: "Please enter a valid verification code.")
            return false
        }
        if ((newPasswordTextField.text?.characters.count)! > 0 && (!self.isValidPassword(password: newPasswordTextField.text!)))
        {
            self.showAlertControllerWithTitle(title: "Alert", message: "Password must be 6+ characters")
            return false
        }
        
        if ((retypePasswordTextField.text?.characters.count)! > 0 && (!self.isValidPassword(password: retypePasswordTextField.text!)))
        {
            self.showAlertControllerWithTitle(title: "Alert", message: "Password must be 6+ characters and contain at least 1 Uppercase character or 1 numeric or non-alphanumeric character")
            return false
        }
        if(!self.isPasswordSame(password: newPasswordTextField.text!, confirmPassword: retypePasswordTextField.text!))
        {
            self.showAlertControllerWithTitle(title: "Alert", message: "Passwords do not match.")
            return false
        }
        
        return true
    }
    
    func isValidEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
//    func isValidPassword(password: String ) -> Bool {
//        if password.characters.count > 6 {
//            return true
//        }
//        else{
//            return false
//        }
//    }
    
    func isValidPassword(password: String) -> Bool {
        var lowerCaseLetter: Bool = false
        var upperCaseLetter: Bool = false
        var digit: Bool = false
        var specialCharacter: Bool = false
        
        if password.characters.count  > 6 {
            for char in password.unicodeScalars {
                if !lowerCaseLetter {
                    lowerCaseLetter = CharacterSet.lowercaseLetters.contains(char)
                }
                if !upperCaseLetter {
                    upperCaseLetter = CharacterSet.uppercaseLetters.contains(char)
                }
                if !digit {
                    digit = CharacterSet.decimalDigits.contains(char)
                }
                if !specialCharacter {
                    specialCharacter = CharacterSet.punctuationCharacters.contains(char)
                }
            }
            if (specialCharacter || upperCaseLetter || digit)
            {
                print ("correct")
                return true
            }
            else {
                print ("Incorrect")
                
                return false
            }
        }
        return false
    }
    
     func isPasswordSame(password: String , confirmPassword : String) -> Bool {
        if password == confirmPassword{
            return true
        }
        else{
            return false
        }
    }

    


    // MARK: - Alert Handler
    func showAlertControllerWithTitle(title: String?, message: String?)
    {
        let appearance = VitaAlertViewController.SCLAppearance(showCloseButton: false)
        let alert = VitaAlertViewController(appearance: appearance)
        alert.addButton("Ok"){
            print("Ok tapped")
            if(message == "Password updated")
            {
                self.performSegue(withIdentifier:"LoginVC", sender: nil)
            }
        }
        alert.showWarning(title!, subTitle: message!)
    }
    

    //MARK: ResetPassword API Call
    func callResetPasswordService(email: String, verification_code: String, password:String, confirm_password:String, token:String) {
        let resetPassword = ServicePath.resetPassword(email: email, verification_code: verification_code, password: password, confirm_password: confirm_password, token: token)
        resetPasswordViewModel.delegate = self
        resetPasswordViewModel.apiCallWithType(type: resetPassword)
        
    }
    
    //MARK: -  Helper Methods...
    
    func resignTextFields()
    {
         emailAddressTextField.resignFirstResponder()
         verificationCodeTextField.resignFirstResponder()
         newPasswordTextField.resignFirstResponder()
         retypePasswordTextField.resignFirstResponder()
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



extension VerificationCodeViewController:BaseModelDelegate {
    func refreshController(model:BaseViewModels?,info:Any?,error:Error?) {
        //Refresh the screen over here...
        VitaActivityIndicator.hideIndicator()
        if(error == nil)
        {
            print("ResetPassword info\(String(describing: resetPasswordViewModel.resetPasswordInfo?.token))")
            self.showAlertControllerWithTitle(title: "Alert", message: resetPasswordViewModel.resetPasswordInfo?.message )

        }
        else
        {
            print("error is \(String(describing: error))")
            self.showAlertControllerWithTitle(title: "Error", message: error?.localizedDescription )
        }
    }
}
