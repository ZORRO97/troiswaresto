//
//  Review.swift
//  troiswaresto
//
//  Created by etudiant-11 on 25/04/2016.
//  Copyright © 2016 francois. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Review {
    var description:String?
    var rating:Double
    var nickname:String?
    var date: NSDate?
    // var restoId: Int
    init(rating:Double){
        self.rating = rating
        // self.restoId = restoId
    }
    
    
    func persistReviewInCoreData(coreUser: CoreDataUser)->Bool {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let entity = NSEntityDescription.entityForName("CoreDataReview", inManagedObjectContext: managedObjectContext)!
        let oneCoreDataReview = CoreDataReview(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
        
        oneCoreDataReview.avis = self.description
        oneCoreDataReview.rating = self.rating
        oneCoreDataReview.nickname = self.nickname
        oneCoreDataReview.date = self.date
        oneCoreDataReview.user = coreUser
        
        do {
            try managedObjectContext.save()
            return true
            
        } catch let error as NSError {
            logError("Error to save:\(error.description)")
            return false
        }
    }

}
