//
//  FacebookEmailRegisterViewController.swift
//  Vita
//
//  Created by Shemona.Puri on 02/08/17.
//  Copyright © 2017 Mobileprogramming. All rights reserved.
//

import UIKit

class FacebookEmailRegisterViewController: UIViewController {

    @IBOutlet weak var emailAddressTextField: UITextField!
    var fbAccessToken : String?

    let viewModelReg = RegistrationViewModel()
    var deviceID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        deviceID = UIDevice.current.identifierForVendor!.uuidString

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   

    //MARK: Action Methods
    @IBAction func privacyClicked(sender: UIButton){
    }
    @IBAction func backClicked(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }

    
    @IBAction func RegisterClicked(sender: UIButton){
        if (!self.checkValidation())
        {
            return
        }
        else
        {
            emailAddressTextField.resignFirstResponder()
            VitaActivityIndicator.showIndicator(containerView: self.view)
            self.callFacebookRegService(email: emailAddressTextField.text!, device_id: self.deviceID, facebook_id: fbAccessToken!, device_token: "7575")

        }
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

    func callFacebookRegService(email: String, device_id:String,facebook_id: String,device_token:String ) {
        let registration = ServicePath.registration(email: email, password: "", device_id: deviceID, device_type: "1",authentication_type: "facebook", facebook_id: facebook_id, guid: "",device_token: device_token)
        viewModelReg.delegate = self
        viewModelReg.apiCallWithType(type: registration)
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FacebookEmailRegisterViewController:BaseModelDelegate {
    func refreshController(model:BaseViewModels?,info:Any?,error:Error?) {
        //Refresh the screen over here...
        VitaActivityIndicator.hideIndicator()
        
        if(error == nil)
        {
            print("registered user info\(String(describing: viewModelReg.regUserInfo?.token))")
            APPDELEGATE.isUserLoggedIn = false
            self.performSegue(withIdentifier:"ContainerVC", sender: nil)
        }
        else
        {
            print("error is \(String(describing: error))")
            self.showAlertControllerWithTitle(title: "Error", message: error?.localizedDescription )
        }
    }
}

