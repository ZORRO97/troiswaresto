//
//  FirebaseHelper.swift
//  troiswaresto
//
//  Created by etudiant-11 on 06/05/2016.
//  Copyright © 2016 francois. All rights reserved.
//

import Foundation
import Firebase


class FirebaseHelper {
    
    static func createFirebaseUser(email: String, password: String, nickname : String){
    let rootRef = Firebase(url: firebaseUrl)
    NSLog("appel de création user")
    rootRef.createUser(email, password: password, withValueCompletionBlock: { (error,result) in
        if error == nil {
            NSLog("user created avec result \(result)")
            rootRef.childByAppendingPath("user/\(result["uid"]!)").setValue(["email" : email, "nickname": nickname])
        } else {
            NSLog("problem to create user")
        }
    
    })
}

}