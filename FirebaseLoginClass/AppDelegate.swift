//
//  AppDelegate.swift
//  FirebaseLoginClass
//
//  Created by indianic on 26/09/17.
//  Copyright © 2017 indianic. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let kFbURLScheme = "fb119427038776347"
    let kGoogleURLScheme = "com.googleusercontent.apps.918701732824-muqe4855cel1c0hqrvushm0072ep8t4q"
    let kTwitterURLScheme = "twitterkit-0C0WJ28R8uPkqR3YYwotQAW5m"
    let kTwitterAPIKey = "0C0WJ28R8uPkqR3YYwotQAW5m" //Consumer KEY
    let kTwitterSecretKey = "c1o1KGXvxXoulMe7PB34kBEDfluZDC2jycqYkKX7lqAPPr6XEj"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        FIRApp.configure()
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        Twitter.sharedInstance().start(withConsumerKey: kTwitterAPIKey, consumerSecret:kTwitterSecretKey)

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
        
        if url.scheme == kFbURLScheme{
            let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
            return handled
        }else if url.scheme == kGoogleURLScheme{
            return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        }else if url.scheme == kTwitterURLScheme{
               return Twitter.sharedInstance().application(app, open: url, options: options)
        }else{
            return true
        }
    }


}

