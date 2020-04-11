//
//  LunchViewController.swift
//  CMU_WFM
//
//  Created by Methawin on 11/4/2563 BE.
//  Copyright © 2563 Methawin. All rights reserved.
//

import UIKit
import Alamofire
import ImageSlideshow
import Kingfisher

class LunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let user = LocalFile.getUser()
        if let token = user?.token {
            print("Hi", token)
            self.performSegue(withIdentifier: "gotoViewController", sender: self)
        } else {
            self.performSegue(withIdentifier: "gotoLogin", sender: self)
        }
    }
    
}
