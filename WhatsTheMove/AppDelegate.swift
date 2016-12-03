//
//  AppDelegate.swift
//  WhatsTheMove
//
//  Created by Tyler Encke on 9/20/16.
//  Copyright © 2016 WhatsTheMove. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    
    let WTM = WTMSingleton.instance
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        if let currentUser = WTM.auth.currentUser {
            currentUser.reload() { (err) in
                if err == nil {
                    self.userExists(of: currentUser.uid) { (exists) in
                        if exists {
                            // Push to Feed View Controller
                            let vc = storyboard.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController
                            self.window?.rootViewController = vc
                            self.window?.makeKeyAndVisible()
                        } else {
                            // Push to New Account View Controller
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "newAccountViewController") as? NewAccountViewController
                            self.window?.rootViewController = vc
                            self.window?.makeKeyAndVisible()
                        }
                    }
                }
            }
        }
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(
            url,
            sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
            annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        var options: [String: AnyObject] = [UIApplicationOpenURLOptionsKey.sourceApplication.rawValue: sourceApplication as AnyObject, UIApplicationOpenURLOptionsKey.annotation.rawValue: annotation as AnyObject]
        return GIDSignIn.sharedInstance().handle(url as URL!,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        let authentication = user.authentication
        let credential = FIRGoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!,
                                                          accessToken: (authentication?.accessToken)!)
        
        WTM.auth.signIn(with: credential) { (user, error) in
            if let user = user {
                print(user.uid)
                // Validate user has set their username. If not send to NewAccountViewController
                self.userExists(of: user.uid) { (exists) in
                    if exists {
                        // Push to Feed View Controller
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController
                        self.window?.rootViewController = vc
                        self.window?.makeKeyAndVisible()
                    } else {
                        // Push to New Account View Controller
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "newAccountViewController") as? NewAccountViewController
                        self.window?.rootViewController = vc
                        self.window?.makeKeyAndVisible()
                    }
                }
                
            }
            if let error = error {
                print(error.localizedDescription)
            }
            
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // Push to Login View Controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "loginViewController") as? LoginViewController
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        
        // TODO? If needed also clean up extra stuff here
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
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(application: UIApplication,
                     openURL url: NSURL,
                     sourceApplication: String?,
                     annotation: AnyObject?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            openURL: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }
}
