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

class LoginViewController: UIViewController, GIDSignInUIDelegate, FBSDKLoginButtonDelegate {
    
    let WTM = WTMSingleton.instance
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    @IBOutlet weak var facebookSignInButton: FBSDKLoginButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Automatically sign in the user.
        GIDSignIn.sharedInstance().signInSilently()
        // Configure the sign-in button look/feel
        googleSignInButton.style = GIDSignInButtonStyle.wide
        
        // Facebook Signin
        facebookSignInButton.readPermissions = ["public_profile", "email", "user_friends"]
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
                        // Load Events
                        self.WTM.reloadEvents()
                        
                        // Validate user has set their username. If not send to NewAccountViewController
                        self.userExists(of: user.uid)
                    }
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
                
            }
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        WTM.auth.signIn(with: credential) { (user, error) in
            if let user = user {
                // Load Events
                self.WTM.reloadEvents()
                
                // Validate user has set their username. If not send to NewAccountViewController
                self.userExists(of: user.uid)
            }
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logout Facebook")
    }
    
    // Handle checking if user exists for login view
    func userExists(of uid: String) {
        WTM.userExists(of: uid) { (exists) in
            if exists {
                // User exists in DB
                // Push to Feed View Controller
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController
                self.present(vc!, animated: true)
                return
            } else {
                // User is not in DB
                
                // Push to New Account View Controller
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "newAccountViewController") as? NewAccountViewController
                self.present(vc!, animated: true)
                return
            }
        }
    }
}
