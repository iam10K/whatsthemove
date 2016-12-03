//
//  LoginController.swift
//  WhatsTheMove
//
//  Created by Tyler Encke on 10/8/16.
//  Copyright © 2016 WhatsTheMove. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, GIDSignInUIDelegate , FBSDKLoginButtonDelegate{
    
    let WTM = WTMSingleton.instance
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Uncomment to automatically sign in the user.
        GIDSignIn.sharedInstance().signInSilently()
        
        // TODO(developer) Configure the sign-in button look/feel
        googleSignInButton.style = GIDSignInButtonStyle.wide
        
        if (FBSDKAccessToken.current() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
        }
        else
        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }
        
    
}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonAction() {
        if let email = emailField.text {
            
            if let password = passwordField.text {
                
                WTM.auth.signIn(withEmail: email, password: password) { (user, error) in
                    if let user = user {
                        print(user.uid)
                        // Validate user has set their username. If not send to NewAccountViewController
                        self.userExists(of: user.uid) { (exists) in
                            if exists {
                                // Push to Feed View Controller
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController
                                self.present(vc!, animated: true)
                            } else {
                                // Push to New Account View Controller
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "newAccountViewController") as? NewAccountViewController
                                self.present(vc!, animated: true)
                            }
                        }
                        
                    }
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
                
            }
        }
    }
    
    // Validate user has set their username in the DB
    private func userExists(of uid: String, completion: ((Bool) -> Void)?) {
        WTM.dbRef.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(uid) {
                // User exists in DB
                completion?(true)
                return
            } else {
                // User is not in DB
                completion?(false)
            }
            
        }) { (error) in
            print(error.localizedDescription)
            completion?(false)
        }
        
    }
    
    // Login using Firebase Auth to authenticate with Facebook
    @IBAction func facebookLoginAction() {
        
        
        
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        println("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        println("User Logged Out")
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
            }
            else
            {
                println("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                println("User Name is: \(userName)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                println("User Email is: \(userEmail)")
            }
        })
    }

}
