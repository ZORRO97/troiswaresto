//
//  User.swift
//  troiswaresto
//
//  Created by etudiant-11 on 06/05/2016.
//  Copyright © 2016 francois. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class User {
    var email: String
    var password: String
    var nickname :  String
    var userId: String
    
    init(email: String, nickname: String, userId: String, password : String){
        self.email = email
        self.password = password
        self.nickname = nickname
        self.userId = userId
    }
    
    func persistUserInUserDefaults(){
        NSUserDefaults.standardUserDefaults().setObject(self.email, forKey: "email")
        NSUserDefaults.standardUserDefaults().setObject(self.nickname, forKey: "nickname")
        NSUserDefaults.standardUserDefaults().setObject(self.password, forKey: "password")
        NSUserDefaults.standardUserDefaults().setObject(self.userId, forKey: "userId")
    }
    
    
    
    func persistUserInCoreData()->Bool {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let entity = NSEntityDescription.entityForName("CoreDataUser", inManagedObjectContext: managedObjectContext)!
        if CoreDataHelper.fetchUser(self.userId) == nil {
            let oneCoreDataUser = CoreDataUser(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
            
            oneCoreDataUser.email = self.email
            oneCoreDataUser.nickname = self.nickname
            oneCoreDataUser.password = self.password
            oneCoreDataUser.userId = self.userId
            
            do {
                try managedObjectContext.save()
                return true
                
            } catch let error as NSError {
                logError("Error to save:\(error.description)")
                return false
            }
        } else {
            return false
        }
    }
    
    func removeUserInCoreData(userCoreData: CoreDataUser){
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        managedObjectContext.deleteObject(userCoreData as NSManagedObject)
    }
    
}


func getUserFromUserDefaults()->User? {
    
    if let myEmail = NSUserDefaults.standardUserDefaults().objectForKey("email") as? String ,
        let myNickname = NSUserDefaults.standardUserDefaults().objectForKey("nickname") as? String,
        let myPassword = NSUserDefaults.standardUserDefaults().objectForKey("password") as? String,
        let myUserId = NSUserDefaults.standardUserDefaults().objectForKey("userId") as? String {
        return User(email: myEmail, nickname: myNickname, userId: myUserId, password: myPassword)
    } else {
        return nil
    }
    
}


