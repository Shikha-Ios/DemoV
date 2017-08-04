//
//  LoginViewController.swift
//  Vita
//
//  Created by Shemona.Puri on 17/07/17.
//  Copyright © 2017 Mobileprogramming. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class LoginViewController: UIViewController,GIDSignInDelegate , GIDSignInUIDelegate, UITextFieldDelegate {
 

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let viewModel = LoginViewModel()
    var deviceID: String!
    let viewModelReg = RegistrationViewModel()
    var fbAccessToken : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        deviceID = UIDevice.current.identifierForVendor!.uuidString
     
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
    
    @IBAction func signInClicked(sender: UIButton){
        if (!self.checkValidation())
        {
            return
        }
        else
        {
            self.resignTextFields()
            VitaActivityIndicator.showIndicator(containerView: self.view)
           // self.callLoginService(email: "shemona.puri@mobileprogrammingllc.com", password: "welcome")
            self.callLoginService(email: userNameTextField.text!, password: passwordTextField.text!,device_token: "123456")
        }
    }
    
    @IBAction func facebookSignInClicked(sender: UIButton){
        VitaActivityIndicator.showIndicator(containerView: self.view)

        self.fbLoginButtonClicked()

    }
    
    @IBAction func googlePlusSignInClicked(sender: UIButton){
        VitaActivityIndicator.showIndicator(containerView: self.view)
        GIDSignIn.sharedInstance().signIn()

    }
    
    @IBAction func privacyClicked(sender: UIButton){
    }
    
    @IBAction func forgotPasswordClicked(sender: UIButton){
        self.performSegue(withIdentifier:"PasswordVC", sender: nil)
    }
    
    // MARK: UITextField Delegates
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }

    
    //MARK: Login API Call
    func callLoginService(email: String, password: String, device_token: String) {
        let login = ServicePath.login(email: email, password: password, device_token: device_token)
        viewModel.delegate = self
        viewModel.apiCallWithType(type: login)
    }
    
    func callFacebookRegService(email: String, device_id:String,facebook_id: String , device_token:String) {
        let registration = ServicePath.registration(email: email, password: "", device_id: deviceID, device_type: "1",authentication_type: "facebook", facebook_id: facebook_id, guid: "",device_token: device_token)
        
        viewModelReg.delegate = self
        viewModelReg.apiCallWithType(type: registration)
    }
    
    func callGoogleRegService(email: String, device_id:String, google_id: String ,device_token:String) {
        let registration = ServicePath.registration(email: email, password: "", device_id: deviceID, device_type: "1",authentication_type: "google", facebook_id: "", guid: google_id,device_token: device_token)
        viewModelReg.delegate = self
        viewModelReg.apiCallWithType(type: registration)
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
    
    //MARK: -  Google Plus Sign In Delegates
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            VitaActivityIndicator.hideIndicator()

            print(error.localizedDescription)
            return
        }
        let authentication = user.authentication
        let profile = user.profile
        print("Access token:", authentication?.accessToken! ?? "" )
        print("userProfile email:",profile?.email ?? "" )
        print("userProfile name:",profile?.name ?? "" )
        
        // Call API for Registration
        self.callGoogleRegService(email: (profile?.email)!, device_id: deviceID,google_id: (authentication?.accessToken!)!,device_token: "1234566")

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
                    self.fbAccessToken = response.dictionaryValue?["id"] as! String
                    print("no email id")
                    VitaActivityIndicator.hideIndicator()
                    self.performSegue(withIdentifier:"FbEmailVC", sender: nil)

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
            print("Ok tapped")
        }
        alert.showWarning(title!, subTitle: message!)
    }
    
    //MARK: -  Helper Methods...
    
    func resignTextFields()
    {
        userNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }



    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "FbEmailVC") {
            // pass data to next view
            let viewController: FacebookNoEmailViewController = (segue.destination as? FacebookNoEmailViewController)!
            viewController.fbAccessToken = fbAccessToken
        }

    }
    
}

extension LoginViewController:BaseModelDelegate {
    func refreshController(model:BaseViewModels?,info:Any?,error:Error?) {
        //Refresh the screen over here...
         VitaActivityIndicator.hideIndicator()
        if(error == nil)
        {
            let str_identifier = info as! String
            if(str_identifier == "Registration")
            {
                
                print("login fb or google info\(String(describing: viewModelReg.regUserInfo?.email))")
                APPDELEGATE.isUserLoggedIn = false
                self.performSegue(withIdentifier:"ContainerVC", sender: nil)
            }
            if(str_identifier == "Login")
            {
                print("login user info\(String(describing: viewModel.userInfo?.email))")
                APPDELEGATE.isUserLoggedIn = false
                self.performSegue(withIdentifier:"ContainerVC", sender: nil)
            }
          
        }
        else
        {
            print("error is \(String(describing: error))")
            self.showAlertControllerWithTitle(title: "Error", message: error?.localizedDescription )
        }
    }
}
