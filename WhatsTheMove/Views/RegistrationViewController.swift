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
    
    let WTM = WTMSingleton.instance
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardWhenTappedAround() 
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
                        // TODO: Message, Passwords do not match
                        let alert = UIAlertController(title: "Alert", message: "Passwords Dont Match", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Dismiss ", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
        
                        return
                    } else {
                        if password.characters.count < 6 {
                            // TODO: Message, Password is too short
                            let alert = UIAlertController(title: "Alert", message: "Password Too Short", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            

                            return
                        }
                        if password.characters.count > 32 {
                            // TODO: Message. Password is too long
                            let alert = UIAlertController(title: "Alert", message: "Password Too Long", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Dismiss ", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            

                            return
                        }
                    }
                    
                    self.createUserAccount(with: email, and: password)
                    
                } else {
                    // TODO: Message, Password not confirmed
                    let alert = UIAlertController(title: "Alert", message: "Password Not Confirmed", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Dismiss ", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    

                }
            } else {
                // TODO: Message, No password entered
                    let alert = UIAlertController(title: "Alert", message: "No Password entered", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss ", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                

            }
        } else {
            // TODO: Message, No email entered
            let alert = UIAlertController(title: "Alert", message: "No Email Entered", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss ", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            

        }
    }
    
    
    // TODO Keyboard next button goes to next field.
    // http://stackoverflow.com/questions/9540500/ios-app-next-key-wont-go-to-the-next-text-field
    // http://stackoverflow.com/questions/1347779/how-to-navigate-through-textfields-next-done-buttons
    
    
    /// Creates the user within Firebase auth using email/password.
    func createUserAccount(with email: String, and password: String) {
        WTM.auth.createUser(withEmail: email, password: password) { (user, error) in
            
            // Success
            if user != nil {
                // Push to create a new account
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "newAccountViewController") as? NewAccountViewController
                self.present(vc!, animated: true)
            }
            
            // Error
            if let error = error {
                // TODO: Handle errors, print messages, etcs
                print(error.localizedDescription)
            }
            
        }
    }
}
