//
//  LoginController.swift
//  WhatsTheMove
//
//  Created by Tyler Encke on 10/8/16.
//  Copyright © 2016 WhatsTheMove. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonAction() {
        if let email = emailField.text {
            
            
            if let password = passwordField.text {
                FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
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
