//
//  AppDelegate.swift
//  Vita
//
//  Created by Shemona.Puri on 17/07/17.
//  Copyright © 2017 Mobileprogramming. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import IQKeyboardManagerSwift

@UIApplicationMain



class AppDelegate: UIResponder {
var isUserLoggedIn = true
    var window: UIWindow?
    class func sharedDelegate()->AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}

//MARK UIApplication Delegates
extension AppDelegate : UIApplicationDelegate {
  
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      
        

               // Initialize sign-in
        var configureError: NSError?
        
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
    

        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication)
    {
        
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let googleDidHandle = GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        let facebookDidHandle = SDKApplicationDelegate.shared.application(app, open: url, options: options)

        
     
        return googleDidHandle || facebookDidHandle
    }
    
       
//    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
//    }
    

  

}
