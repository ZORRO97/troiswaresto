//
//  User.swift
//  troiswaresto
//
//  Created by etudiant-11 on 06/05/2016.
//  Copyright © 2016 francois. All rights reserved.
//

import Foundation


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
