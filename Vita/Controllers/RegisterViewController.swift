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

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self

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
    
    @IBAction func signUpClicked(sender: UIButton){
        
        self.performSegue(withIdentifier:"ContainerVC", sender: nil)
        
        /*
        if (!self.checkValidation())
        {
            return
        }
        else
        {
        self.performSegue(withIdentifier:"ContainerVC", sender: nil)
        }
 */
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
    
    //MARK: -  Input Validation Methods/Alert Methods...
    func checkValidation() ->Bool
    {
        if(emailAddressTextField.text?.characters.count == 0 && passwordTextField.text?.characters.count == 0 )
        {
            print("Please enter information")
            return false
        }
            if (emailAddressTextField.text?.characters.count == 0)
        {
            print("Please enter the valid email")
            return false
        }
        if (emailAddressTextField.text?.characters.count == 0)
        {
            print("Please enter the valid password")
            return false
        }
        if ((emailAddressTextField.text?.characters.count)! > 0 && (!self.isValidEmail(email: emailAddressTextField.text as String!)))
        {
            print("Please enter the valid email")
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
            print(error.localizedDescription)
            return
        }
        
        let authentication = user.authentication
        let profile = user.profile

        print("Access token:", authentication?.accessToken!)
        print("userProfile email:",profile?.email)
        print("userProfile name:",profile?.name)

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
                print("Graph Request Succeeded: \(response)")
                print("Custom Graph Request Succeeded: \(response)")
                print("My facebook id is \(response.dictionaryValue?["id"])")
                print("My name is \(response.dictionaryValue?["name"])")
                
            case .failed(let error):
                print("Graph Request Failed: \(error)")
            }
        }
        connection.start()
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
