//
//  FirebaseSocialLogin.swift
//  FirebaseSocialLogin
//
//  Created by Arpit Jain on 26/09/17.
//  Copyright © 2017 Arpit Jain. All rights reserved.
//


import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import TwitterKit
import GoogleSignIn

class FirebaseSocialLogin: NSObject,GIDSignInUIDelegate ,GIDSignInDelegate{
    
    static let sharedInstance = FirebaseSocialLogin()
    var presentVC : UIViewController?
    typealias completionBlock = ([String : Any]?) -> Void
    var block : completionBlock?
    
    // MARK: - Twitter Login Methods
    
    func twitterLogin(_ VC : UIViewController , completionHandler:@escaping ([String : Any]?) -> Void){
        Twitter.sharedInstance().logIn(with: VC) { (session, error) in
            
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            if session != nil{
                let credential = FIRTwitterAuthProvider.credential(withToken: (session?.authToken)!, secret: (session?.authTokenSecret)!)
                
                FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                    if let error = error {
                        print("Failed to login: \(error.localizedDescription)")
                        completionHandler(nil)
                        return
                    } else{
                        if let user = FIRAuth.auth()?.currentUser {
                            print(user.displayName!)
                            print(user.photoURL!)
                            let userData = ["Social_type" : "facebook",
                                            "Social_id" :  user.uid ,
                                            "First_name" : user.displayName! ,
                                            "Email_id" : user.email! ,
                                            "Image_url" : user.photoURL?.absoluteString ?? "",
                                            ]
                            completionHandler(userData)
                            
                        }
                    }
                })
            }
        }
    }
    
    // MARK: - FBSignIn Methods
    
    func fBLogin(_ VC : UIViewController, completionHandler:@escaping ([String : Any]?) -> Void) {
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logOut()
        
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: VC, handler: {(result, error) -> Void in
            
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Failed to login: \(error.localizedDescription)")
                    completionHandler(nil)
                    return
                } else{
                    if let user = FIRAuth.auth()?.currentUser {
                        print(user.displayName!)
                        print(user.photoURL!)
                        let userData = ["Social_type" : "facebook",
                                        "Social_id" :  user.uid ,
                                        "First_name" : user.displayName! ,
                                        "Email_id" : user.email! ,
                                        "Image_url" : user.photoURL?.absoluteString ?? "",
                                        ]
                        completionHandler(userData)
                    }
                }
            })
        })
    }
    
    // MARK: - GIDSignIn Methods
    
    func googleLogin(_ VC : UIViewController , completionHandler:@escaping completionBlock){
        
        presentVC = VC
        block = completionHandler
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
        GIDSignIn.sharedInstance().shouldFetchBasicProfile = true
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        
        if error != nil {
            if block != nil {
                block!(nil)
            }
            return
        }else{
            
            guard let authentication = user.authentication else { return }
            let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                              accessToken: authentication.accessToken)
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                
                if let error = error {
                    print(error)
                    return
                }else{
                    let dictUser = ["Social_type" : "google",
                                    "Social_id" : user?.uid ?? "",
                                    "Name" : user?.displayName! ?? "",
                                    "Email_id" : user?.email! ?? "",
                                    "Image_url" :  user?.photoURL?.absoluteString ?? ""
                    ]
                    if self.block != nil {
                        self.block!(dictUser)
                    }
                }
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!){
        
        if (presentVC != nil){
            presentVC?.present(viewController, animated: true, completion: nil)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!){
        if (presentVC != nil){
            presentVC?.dismiss(animated: true, completion: nil)
        }
    }
}

