//
//  Resto.swift
//  troiswaresto
//
//  Created by etudiant-11 on 25/04/2016.
//  Copyright © 2016 francois. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Firebase

class Resto {
    
    let restoId:String
    var name: String
    var position : CLLocation
    var description : String?
    var reviews = [Review]()
    var rating: Double? {
        if self.reviews.count != 0 {
        var total = 0.0
        for review in self.reviews {
            total += review.rating
        }
        return total / Double(self.reviews.count)
        } else {
            return nil
        }
    }
    
    var address: String {
        return "120 rue des poissonniers 75018 PARIS"
    }
    var image: UIImage?
    var priceRange : PriceRange?
    var distance: CLLocationDistance {
        return 0
    }
    
    func addReviewInCloud(review: Review, completionhandler: (success: Bool) ->()){
        // ajouter une review dans firebase
        // let firebaseUrl = "https://sweltering-heat-2058.firebaseio.com"
        let ref = Firebase(url: firebaseUrl)
        let refResto = ref.childByAppendingPath("data/resto/\(restoId)/reviews")
        let refReview = refResto.childByAutoId()
       
        // refReview.childByAppendingPath("rating").setValue(review.rating)
        
        
        refReview.childByAppendingPath("rating").setValue(review.rating, withCompletionBlock:{
            (error: NSError!, myref: Firebase!) -> () in
            completionhandler(success: true)
        })
        
        if let myDescription = review.description {
            refReview.childByAppendingPath("description").setValue(myDescription)
        }
        if let myNickname = review.nickname {
            refReview.childByAppendingPath("nickname").setValue(myNickname)
        }
    }
    
    
    init (restoId:String,name: String, position: CLLocation){
        self.restoId = restoId
        self.name = name
        self.position = position
    }
    
}

enum PriceRange: Int {
    case Cheap = 0
    case Normal = 1
    case Expensive = 2
    // PriceRange(rawValue: <#T##Int#>) récupérer valeur PriceRange à partir de l'entier correspondant
    // let toto = PriceRange.Cheap.rawValue récupérer la valeur de l'entier correspondant
}


// TO DO
// enregistrer un resto ds firebase
func addRestoInCloud(resto: Resto){
    let ref = Firebase(url: firebaseUrl)
    let refRestos = ref.childByAppendingPath("data/resto")
    let refResto = refRestos.childByAutoId()
    refResto.childByAppendingPath("name").setValue(resto.name)
    
}
