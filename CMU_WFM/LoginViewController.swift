//
//  LoginViewController.swift
//  CMU_WFM
//
//  Created by Methawin on 6/4/2563 BE.
//  Copyright © 2563 Methawin. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func facebookLoginTapped(_ sender: Any) {
        login(accessToken: "fTj9pAjhHtDsAcSuRU0B7qWJRKE4dxd02", email: "pai.pp@hotmail.co.th", loginType: "F", profileName: "g")
    }
    
    @IBAction func gmailLoginTappped(_ sender: Any) {
        login(accessToken: "fTj9pAjhHtDsAcSuRU0B7qWJRKE4dxd02", email: "pai.pp@hotmail.co.th", loginType: "G", profileName: "g")
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
