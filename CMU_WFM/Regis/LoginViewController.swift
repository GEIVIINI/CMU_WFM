//
//  LoginViewController.swift
//  CMU_WFM
//
//  Created by Methawin on 6/4/2563 BE.
//  Copyright © 2563 Methawin. All rights reserved.
//

import UIKit
import Alamofire
import FacebookLogin
import FacebookCore
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func facebookLoginTapped(_ sender: Any) {
        let login = LoginManager()
        login.logIn(permissions: ["public_profile", "email"],
            from: self,
            handler: {(result,error) in
                if error != nil {
                    print("Error : ", error as Any)
                }else if(result?.isCancelled)!{
                    print("Cancel")
                }else{
                    self.getFBUserInfo()
                }
        })
    }
    
    func getFBUserInfo() {
        let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, email, name, picture.type(large)"], tokenString: AccessToken.current?.tokenString, version: Settings.defaultGraphAPIVersion, httpMethod: HTTPMethod.get)
        graphRequest.start(completionHandler: { (fields, result, error) in
            if(error == nil) {
                let dict = result as! NSDictionary
                if let email = dict.object(forKey: "email") as? String,
                    let name = dict.object(forKey: "name") as? String,
                    let token = AccessToken.current?.tokenString {
                        self.login(accessToken: token, email: email, loginType: "F", profileName: name)
                }
            }
        })
    }
    
    @IBAction func gmailLoginTappped(_ sender: Any) {
        GIDSignIn.sharedInstance().clientID = "23212872162-a7sqgj6i36qc2373foqljck0a3bcr590.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
        if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
            print("The user has not signed in before or they have since signed out.")
        } else {
            print("\(error.localizedDescription)")
        }
            return
        }
        let idToken = user.authentication.idToken
        let fullName = user.profile.name
        let email = user.profile.email
        if let token = idToken, let name = fullName, let gEmail = email {
            login(accessToken: token, email: gEmail, loginType: "G", profileName: name)
        }
    }
    
    func login(accessToken: String, email: String, loginType: String, profileName: String) {

        let parameters: [String: AnyObject] = [
            "email" : "pai.pp@hotmail.co.th" as AnyObject,
            "loginType" : "F" as AnyObject,
            "profileName" : "g" as AnyObject,
            "accessToken" : "dfbu22rpfsfkA2e9fS" as AnyObject
        ]

        AF.request("https://b-gib.banana.co.th/wfh/v1r/login", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseJSON { response in
                switch (response.result) {
            case .success:
                if let json = response.value as? [String:Any] {
                    if let results = json["data"] as? [String:Any]   {
                        let user = User(jsonDict: results as NSDictionary)
                        LocalFile.saveUser(user: user)
                        self.performSegue(withIdentifier: "gotoViewController", sender: self)
                    }
                }
          case .failure:
              print("Error")
          }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoViewController" {
        }
    }

    @IBAction func loginPage(segue: UIStoryboardSegue) {
           
    }
    
}
