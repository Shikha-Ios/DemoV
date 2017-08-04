//
//  RegisterViewController.swift
//  Vita
//
//  Created by Shemona.Puri on 17/07/17.
//  Copyright © 2017 Mobileprogramming. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class RegisterViewController: UIViewController, UITextFieldDelegate, GIDSignInDelegate , GIDSignInUIDelegate{

    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    let viewModelReg = RegistrationViewModel()
    var deviceID: String!
    var fbAccessToken : String!

    override func viewDidLoad() {
        super.viewDidLoad()

        deviceID = UIDevice.current.identifierForVendor!.uuidString
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Action Methods
    @IBAction func backClicked(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func signUpClicked(sender: UIButton){
        if (!self.checkValidation())
        {
            return
        }
        else
        {
            self.resignTextFields()
            VitaActivityIndicator.showIndicator(containerView: self.view)
            self.callEmailRegService(email: emailAddressTextField.text!, password: passwordTextField.text!, device_id: deviceID, device_token: "12345")
        }
    }
    
    @IBAction func facebookSignUpClicked(sender: UIButton){
        VitaActivityIndicator.showIndicator(containerView: self.view)

        self.fbLoginButtonClicked()
    }
    
    @IBAction func googlePlusSignUpClicked(sender: UIButton){
        VitaActivityIndicator.showIndicator(containerView: self.view)

        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func privacyClicked(sender: UIButton){
    }

    // MARK: UITextField Delegates
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Registration API Call
    func callEmailRegService(email: String, password: String, device_id:String,device_token:String) {
        
       // let registration = ServicePath.registration(email: "teavdgst5659@gmail.com", password: "1234567", device_id: "111111", device_type: "1",authentication_type: "email", facebook_id: "", guid: "")
        let registration = ServicePath.registration(email: email, password: password, device_id: deviceID, device_type: "1",authentication_type: "email", facebook_id: "", guid: "",device_token: device_token)
        viewModelReg.delegate = self
        viewModelReg.apiCallWithType(type: registration)
    }
    
    func callFacebookRegService(email: String, device_id:String,facebook_id: String,device_token:String ) {
        let registration = ServicePath.registration(email: email, password: "", device_id: deviceID, device_type: "1",authentication_type: "facebook", facebook_id: facebook_id, guid: "",device_token: device_token)
        viewModelReg.delegate = self
        viewModelReg.apiCallWithType(type: registration)
    }
    
    func callGoogleRegService(email: String, device_id:String, google_id: String,device_token:String ) {
        let registration = ServicePath.registration(email: email, password: "", device_id: deviceID, device_type: "1",authentication_type: "google", facebook_id: "", guid: google_id,device_token: device_token)
        viewModelReg.delegate = self
        viewModelReg.apiCallWithType(type: registration)
    }
    
    
    //MARK: -  Input Validation Methods/Alert Methods...
    func checkValidation() ->Bool
    {
        if (emailAddressTextField.text?.characters.count == 0 && passwordTextField.text?.characters.count == 0)
        {
            self.showAlertControllerWithTitle(title: "Alert", message: "Please enter the information")
            return false
        }
        if (emailAddressTextField.text?.characters.count == 0)
        {
            self.showAlertControllerWithTitle(title: "Alert", message: "Please enter the valid email id")
            return false
        }
        if (passwordTextField.text?.characters.count == 0)
        {
            self.showAlertControllerWithTitle(title: "Alert", message: "Please enter a valid password")
            return false
        }
        if ((emailAddressTextField.text?.characters.count)! > 0 && (!self.isValidEmail(email: emailAddressTextField.text as String!)))
        {
            self.showAlertControllerWithTitle(title: "Alert", message: "Please enter the valid email id")
            return false
        }
        if ((passwordTextField.text?.characters.count)! > 0 && (!self.isValidPassword(password: passwordTextField.text!)))
        {
        self.showAlertControllerWithTitle(title: "Alert", message: "Password must be 6+ characters and contain at least 1 Uppercase character or 1 numeric or non-alphanumeric character")
            //self.showAlertControllerWithTitle(title: "Alert", message: "Password must be 6+ characters")
            return false
        }
        return true
    }

      func isValidEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    

    
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

    
    //MARK: -  Google Plus Sign In Delegates
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            VitaActivityIndicator.hideIndicator()

            return
        }
        let authentication = user.authentication
        let profile = user.profile
        print("Access token:", authentication?.accessToken! ?? "" )
        print("userProfile email:",profile?.email ?? "" )
        print("userProfile name:",profile?.name ?? "" )
        // Call API for Registration
        self.callGoogleRegService(email: (profile?.email)!, device_id: deviceID,google_id: (authentication?.accessToken!)!, device_token: "123456")
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        VitaActivityIndicator.hideIndicator()

    }
    
    //MARK: -  Facebook Login Helper Methods
    func fbLoginButtonClicked() {
        
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile, .email, .userFriends ], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                VitaActivityIndicator.hideIndicator()

                print(error)
            case .cancelled:
                VitaActivityIndicator.hideIndicator()

                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("YES! \n--- GRANTED PERMISSIONS ---\n\(grantedPermissions) \n--- DECLINED PERMISSIONS ---\n\(declinedPermissions) \n--- ACCESS TOKEN ---\n\(accessToken)")
                let token = accessToken
                print("Logged in!", token.authenticationToken)
                self.getUserProfile()
                
            }
        }
    }
    
    func getUserProfile () {
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"], accessToken: AccessToken.current, httpMethod: GraphRequestHTTPMethod(rawValue: "GET")!, apiVersion: "2.8")) { httpResponse, result in
            print("result == ", result)
            switch result {
            case .success(let response):
            print("Facebook API response: \(response)")
            
            if let _ = response.dictionaryValue?["email"]{
                print(" email id exists")
                // Call API for Registration
            self.callFacebookRegService(email: response.dictionaryValue?["email"] as! String, device_id: self.deviceID, facebook_id: response.dictionaryValue?["id"] as! String,device_token: "7575")
            }
            else {
                print("no email id")
                self.fbAccessToken = response.dictionaryValue?["id"] as! String
                VitaActivityIndicator.hideIndicator()
                self.showAlertControllerWithTitle(title: "Email Required", message: "Email Id is required to login to Vita App" )

            }
           
            let loginManager = LoginManager()
            loginManager.logOut()
            case .failed(let error):
                VitaActivityIndicator.hideIndicator()
                print("Graph Request Failed: \(error)")
            }
        }
        connection.start()
    }

    // MARK: - Alert Handler
    func showAlertControllerWithTitle(title: String?, message: String?)
    {
        let appearance = VitaAlertViewController.SCLAppearance(showCloseButton: false)
        let alert = VitaAlertViewController(appearance: appearance)
        alert.addButton("Ok"){
            
            if(message == "Email Id is required to login to Vita App")
            {
                self.performSegue(withIdentifier:"FbEmailVC", sender: nil)
            }
            print("Ok tapped")
        }
        alert.showWarning(title!, subTitle: message!)
    }
    
    //MARK: -  Helper Methods...
    
    func resignTextFields()
    {
        emailAddressTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }



    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "FbEmailVC") {
            // pass data to next view
           // let viewController: FacebookEmailRegisterViewController = (segue.destination as? FacebookEmailRegisterViewController)!
           // viewController.fbAccessToken = fbAccessToken
        }

    }
    
}

extension RegisterViewController:BaseModelDelegate {
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
