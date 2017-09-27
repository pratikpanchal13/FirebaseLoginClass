//
//  ViewController.swift
//  FirebaseLoginClass
//
//  Created by indianic on 26/09/17.
//  Copyright © 2017 indianic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnFbLoginClick(_ sender: UIButton) {
        FirebaseSocialLogin.sharedInstance.fBLogin(self) { (dictResponse) in
            
        }
    }
    
    @IBAction func btnGoogleLoginClick(_ sender: UIButton) {
        FirebaseSocialLogin.sharedInstance.googleLogin(self) { (dictResponse) in
            
        }
    }

    @IBAction func btnTwitterLoginClick(_ sender: UIButton) {
        FirebaseSocialLogin.sharedInstance.twitterLogin(self) { (dictResponse) in
            
        }
    }


}

