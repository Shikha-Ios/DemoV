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
       self.callEmailRegService(email: emailAddressTextField.text!, password: passwordTextField.text!, device_id: deviceID)
        }
    }
    
    @IBAction func facebookSignUpClicked(sender: UIButton){
        self.fbLoginButtonClicked()
    }
    
    @IBAction func googlePlusSignUpClicked(sender: UIButton){
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
    func callEmailRegService(email: String, password: String, device_id:String) {
        
       // let registration = ServicePath.registration(email: "teavdgst5659@gmail.com", password: "1234567", device_id: "111111", device_type: "1",authentication_type: "email", facebook_id: "", guid: "")
        let registration = ServicePath.registration(email: email, password: password, device_id: deviceID, device_type: "1",authentication_type: "email", facebook_id: "", guid: "")
        viewModelReg.delegate = self
        viewModelReg.apiCallWithType(type: registration)
    }
    
    func callFacebookRegService(email: String, device_id:String,facebook_id: String ) {
        let registration = ServicePath.registration(email: email, password: "", device_id: deviceID, device_type: "1",authentication_type: "facebook", facebook_id: facebook_id, guid: "")
        viewModelReg.delegate = self
        viewModelReg.apiCallWithType(type: registration)
    }
    
    func callGoogleRegService(email: String, device_id:String, google_id: String ) {
        let registration = ServicePath.registration(email: email, password: "", device_id: deviceID, device_type: "1",authentication_type: "google", facebook_id: "", guid: google_id)
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
            self.showAlertControllerWithTitle(title: "Alert", message: "Password must be 6+ characters")
            return false
        }
        return true
    }

      func isValidEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
     func isValidPassword(password: String ) -> Bool {
        if password.characters.count > 6 {
            return true
        }
        else{
            return false
        }
    }

    
    //MARK: -  Google Plus Sign In Delegates
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        let authentication = user.authentication
        let profile = user.profile
        print("Access token:", authentication?.accessToken! ?? "" )
        print("userProfile email:",profile?.email ?? "" )
        print("userProfile name:",profile?.name ?? "" )
        // Call API for Registration
        self.callGoogleRegService(email: (profile?.email)!, device_id: deviceID,google_id: (authentication?.accessToken!)!)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    //MARK: -  Facebook Login Helper Methods
    func fbLoginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile, .email, .userFriends ], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
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
            // Call API for Registration
            self.callFacebookRegService(email: response.dictionaryValue?["email"] as! String, device_id: self.deviceID, facebook_id: response.dictionaryValue?["id"] as! String)
            case .failed(let error):
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

extension RegisterViewController:BaseModelDelegate {
    func refreshController(model:BaseViewModels?,info:Any?,error:Error?) {
        //Refresh the screen over here...
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
