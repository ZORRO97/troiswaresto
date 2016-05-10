//
//  CoreDataHelper.swift
//  troiswaresto
//
//  Created by etudiant-11 on 10/05/2016.
//  Copyright © 2016 francois. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataHelper {
    
    static func fetchAllUsers()->[CoreDataUser]? {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "CoreDataUser")
        fetchRequest.entity = NSEntityDescription.entityForName("CoreDataUser", inManagedObjectContext: managedObjectContext)
        let sort = NSSortDescriptor(key: "nickname", ascending: false) // mise en place d'un tri ascending : Bool sens du tri
        fetchRequest.sortDescriptors = [sort]
        
        do {
            let theUsers = try managedObjectContext.executeFetchRequest(fetchRequest) as! [CoreDataUser]
            return theUsers
        } catch let error as NSError {
            print("error to fetch all topics:\(error.description)")
            return nil
        }
    }
    
    static func fetchUser(uid : String)->CoreDataUser? {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "CoreDataUser")
        fetchRequest.entity = NSEntityDescription.entityForName("CoreDataUser", inManagedObjectContext: managedObjectContext)
        fetchRequest.predicate = NSPredicate(format: "(userId == %@) ", uid)
        do {
            let theUsers = try managedObjectContext.executeFetchRequest(fetchRequest) as! [CoreDataUser]
            
            if theUsers.count == 1 {
            return theUsers[0]
            } else {
                return nil
            }
            
        } catch let error as NSError {
            print("error to fetch pour uid \(uid) description :\(error.description)")
            return nil
        }
        
        
    }
    
    static func fetchOneUser()->CoreDataUser? {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "CoreDataUser")
        fetchRequest.entity = NSEntityDescription.entityForName("CoreDataUser", inManagedObjectContext: managedObjectContext)
        // fetchRequest.predicate = NSPredicate(format: "(userId == %@) ", uid)
        do {
            let theUsers = try managedObjectContext.executeFetchRequest(fetchRequest) as! [CoreDataUser]
            
            if theUsers.count == 1 {
                return theUsers[0]
            } else {
                return nil
            }
            
        } catch let error as NSError {
            print("error to fetch  description :\(error.description)")
            return nil
        }
        
        
    }
    
    static func existsUser(email: String)-> Bool{
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "CoreDataUser")
        fetchRequest.entity = NSEntityDescription.entityForName("CoreDataUser", inManagedObjectContext: managedObjectContext)
        fetchRequest.predicate = NSPredicate(format: "(email == %@) ", email)
        do {
            let theUsers = try managedObjectContext.executeFetchRequest(fetchRequest) as! [CoreDataUser]
            
            if theUsers.count == 1 {
                return true
            } else {
                return false
            }
            
        } catch let error as NSError {
            print("error to fetch  description :\(error.description)")
            return false
        }
    }
    
    
    static func fetchReviews()->[CoreDataReview]? {
        var myCoreDataReviews = [CoreDataReview]()
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "CoreDataUser")
        fetchRequest.entity = NSEntityDescription.entityForName("CoreDataUser", inManagedObjectContext: managedObjectContext)
        let sort = NSSortDescriptor(key: "nickname", ascending: false) // mise en place d'un tri ascending : Bool sens du tri
        fetchRequest.sortDescriptors = [sort]
        
        do {
            let theUsers = try managedObjectContext.executeFetchRequest(fetchRequest) as! [CoreDataUser]
            for user in theUsers {
                if let myReviews = user.review as? Set<CoreDataReview>  {
                    for review in myReviews {
                        myCoreDataReviews.append(review)
                    }
                }
                
            }
            return myCoreDataReviews
        } catch let error as NSError {
            print("error to fetch all topics:\(error.description)")
            return nil
        }

    }

}