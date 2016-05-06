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
    
    init(email: String, password: String, nickname: String, userId: String){
        self.email = email
        self.password = password
        self.nickname = nickname
        self.userId = userId
    }
}


