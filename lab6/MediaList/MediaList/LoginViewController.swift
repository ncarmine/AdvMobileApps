//
//  LoginViewController.swift
//  MediaList
//
//  Created by Nathan Carmine
//  Copyright © 2017 ncarmine. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let GIDinstance = GIDSignIn.sharedInstance()
        GIDinstance?.clientID = FIRApp.defaultApp()?.options.clientID
        GIDinstance?.delegate = self
        GIDinstance?.uiDelegate = self
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let authentication = user.authentication else {
            return
        }
        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        FIRAuth.auth()?.signIn(with: credential, completion: {(user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            let alert=UIAlertController(title: "MediaList Login", message: "Welcome to MediaList " + (user?.displayName)!, preferredStyle: UIAlertControllerStyle.alert)
            let okAction=UIAlertAction(title: "OK", style: .default, handler: {action in
                self.performSegue(withIdentifier: "gotoMain", sender: nil)
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        try! FIRAuth.auth()?.signOut()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
