//
//  LocalFile.swift
//  CMU_WFM
//
//  Created by Methawin on 7/4/2563 BE.
//  Copyright © 2563 Methawin. All rights reserved.
//

import UIKit

class LocalFile: NSObject {
    
    static func saveUser(user:User){
        let data = NSKeyedArchiver.archivedData(withRootObject: user)
        UserDefaults.standard.set(data, forKey: "user")
        UserDefaults.standard.synchronize()
    }
    
    static func getUser() -> User? {
        if let data:Data = UserDefaults.standard.object(forKey: "user") as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? User
        }
        return nil
    }
    
    static func removeUser() {
        if UserDefaults.standard.object(forKey: "user") != nil {
            UserDefaults.standard.removeObject(forKey: "user")
        }
    }
    
}
