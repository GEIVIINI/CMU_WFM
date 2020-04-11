//
//  User.swift
//  CMU_WFM
//
//  Created by Methawin on 7/4/2563 BE.
//  Copyright © 2563 Methawin. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
  
    var email: String?
    var token: String?
    var displayname: String?
    var image: String?
    
    func toDictionary() -> NSDictionary{
        return [
            "email": email as Any,
            "token": token as Any,
            "displayname": displayname as Any,
            "image": image as Any
        ]
    }
    
    override init() {
    }
    
    init(jsonDict:NSDictionary) {
        email = jsonDict.object(forKey: "email") as? String
        token = jsonDict.object(forKey: "token") as? String
        displayname = jsonDict.object(forKey: "displayname") as? String
        image = jsonDict.object(forKey: "image") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(email, forKey: "email")
        aCoder.encode(token, forKey: "token")
        aCoder.encode(displayname, forKey: "displayname")
        aCoder.encode(image, forKey: "image")
    }
    
    required init?(coder aDecoder: NSCoder) {
        email = aDecoder.decodeObject(forKey: "email") as? String
        token = aDecoder.decodeObject(forKey: "token") as? String
        displayname = aDecoder.decodeObject(forKey: "displayname") as? String
        image = aDecoder.decodeObject(forKey: "image") as? String
    }
    
}
