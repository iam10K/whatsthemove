//
//  RegistrationViewController.swift
//  WhatsTheMove
//
//  Created by Tyler Encke on 10/10/16.
//  Copyright © 2016 WhatsTheMove. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAccountAction() {
        if let email = emailField.text {
            
            
            if let password = passwordField.text {
                
                
                if let passwordConfirm = passwordConfirmField.text {
                    
                    if password != passwordConfirm {
                        
                    }
                    
                    FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                        
                        if let user = user {
                            print(user.uid)
                        }
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        
                    }
                }
            }
        }
    }
    
    // Use Firebase Auth to authenticate with Facebook
    @IBAction func facebookRegisterAction() {
        
    }
    
    // Use Firebase Auth to authenticate with Google
    @IBAction func googleRegisterAction() {
    }
    
    
    // TODO Keyboard next button goes to next field.
    // http://stackoverflow.com/questions/9540500/ios-app-next-key-wont-go-to-the-next-text-field
    // http://stackoverflow.com/questions/1347779/how-to-navigate-through-textfields-next-done-buttons
    
}
