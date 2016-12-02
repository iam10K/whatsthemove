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

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
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
    
}
