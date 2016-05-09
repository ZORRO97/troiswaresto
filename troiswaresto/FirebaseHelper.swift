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
    
    static func logFirebaseUser(email: String, password: String,completion: (uid :  String?)->()){
        let rootRef = Firebase(url: firebaseUrl)
        rootRef.authUser(email, password: password) {
            error, authData in
            if error != nil {
                // an error occured while attempting login
                logError("Erreur d'identification")
                completion(uid : nil)
            } else {
                // user is logged in, check authData for data
                logError(authData.uid)
                completion(uid: authData.uid)
                
            }
        }
    }
    
    static func getFirebaseUser(userId : String, completion: (user : User)->()){
        let rootRef = Firebase(url: firebaseUrl)
        let userRef = rootRef.childByAppendingPath("user/\(userId)")
        var user : User!
        // Attach a closure to read the data at our posts reference
        userRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
           //  print(snapshot.value)
                if let myNickname = snapshot.value.objectForKey("nickname") as? String,
                    let myEmail = snapshot.value.objectForKey("email") as? String {
                    logDebug("userId \(userId)")
                    user = User(email: myEmail, nickname: myNickname, userId: userId, password: "")
                    completion(user: user)
                }
            
           
            }, withCancelBlock: { error in
                print(error.description)
        })
    }
    
    static func disconnectFirebaseUser(){
        let ref = Firebase(url: firebaseUrl)
        ref.unauth()
    }
    
}