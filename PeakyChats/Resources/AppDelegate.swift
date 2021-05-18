//
//  AppDelegate.swift
//  PeakyChats
//
//  Created by Nishant  Kushwaha on 14/05/21.
//

import UIKit
import Firebase
import FBSDKCoreKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate{
    
    
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        GIDSignIn.sharedInstance().clientID=FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate=self
        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
        return GIDSignIn.sharedInstance().handle(url)
        
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            if let error = error {
                print("failed to signin with google: \(error)")
                
            }
            return
        }
        
        guard let user = user else {
            return
        }
        print("Sign in with Google: \(user )")
        
        guard let email=user.profile.email,
              let fname=user.profile.givenName,
              let lname=user.profile.familyName else {
            return
        }
        
        DatabaseManager.shared.userExists(with: email, completion: {exists in
            if !exists {
                //insert to database
                DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: fname, lastName: lname, emailId: email))
            }
        })
        
        guard let authentication = user.authentication else {
            print("Missing auth object of user")
            return
            
        }
        let credential = GoogleAuthProvider.credential(withIDToken:authentication.idToken,
                                                       accessToken:authentication.accessToken)
        FirebaseAuth.Auth.auth().signIn(with: credential, completion: { authResult,error in
            guard authResult != nil,error == nil else{
                print("Something went wrong , Failed to login with google")
                return
            }
            
            //success
            
            print("Signed in with google")
            NotificationCenter.default.post(name: .didLogInNotification, object: nil)
        })
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Google user disconnected")
    }
    
    
    
    
    
}





