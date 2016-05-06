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
    
    var address: String?
    var image: UIImage?
    var priceRange : PriceRange?
    var distance: CLLocationDistance?
    
    func setDistanceToUser(userPosition : CLLocation) {
        
        self.distance = userPosition.distanceFromLocation(self.position)
    }
    
    /*
    func getReview(completionhandler: ()->([Review])){
        let ref = Firebase(url: firebaseUrl)
        let refRestoReviews = ref.childByAppendingPath("data/resto/\(restoId)/reviews")
       // let snapshot = refRestoReviews. as! FDataSnapshot
        let myReviews = hydrateReviews(snapshot)
        completionhandler(reviews : myReviews)
    }
    */
    
    func addReviewInCloud(review: Review, completionhandler: (success: Bool) ->()){
        // ajouter une review dans firebase
        // let firebaseUrl = "https://sweltering-heat-2058.firebaseio.com"
        let ref = Firebase(url: firebaseUrl)
        let refResto = ref.childByAppendingPath("data/resto/\(restoId)/reviews")
        let refReview = refResto.childByAutoId()
       
        // refReview.childByAppendingPath("rating").setValue(review.rating)
        
        
        refReview.childByAppendingPath("rating").setValue(review.rating, withCompletionBlock:{
            (error: NSError!, myref: Firebase!) -> () in
                completionhandler(success: (error != nil) ? false : true)
        })
        
        if let myDescription = review.description {
            refReview.childByAppendingPath("description").setValue(myDescription)
        }
        if let myNickname = review.nickname {
            refReview.childByAppendingPath("nickname").setValue(myNickname)
        }
    }
    
    
    init (restoId:String, name: String, position: CLLocation){
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


// TODO:
// enregistrer un resto ds firebase
func addRestoInCloud(name: String, address : String, position : CLLocation, description : String?, priceRange : PriceRange,image: UIImage?, completionhandler : (success : Bool)->() ){
    let refRestos = Firebase(url: "\(firebaseUrl)/data/resto")
    
    let refResto = refRestos.childByAutoId()   // créer un nouvel id resto
    var myDico = ["name" : name, "address": address]
    if let myDescription = description {
       
        myDico["description"] = myDescription
    }
    refResto.setValue(myDico)
    
   
    refResto.childByAppendingPath("position").setValue(["lat": position.coordinate.latitude, "long" :position.coordinate.longitude])
    
    
    refResto.childByAppendingPath("priceRange").setValue(priceRange.rawValue)
    
    // TODO: gérer les images dans Firebase
    
    
    
    if let myImage = image {
            logWarning("lancement récupération images")
            uploadImageToFirebase(myImage) {(imageId) in
                logWarning("sauve id image \(imageId)")
            refResto.childByAppendingPath("imageId").setValue(imageId)
                completionhandler(success: true)
        }
    } else {
        completionhandler(success : false)
    }
    

}

func delRestoInCloud(restoId: String, completionHandler : (success: Bool)->()){
    let refResto = Firebase(url: "\(firebaseUrl)/data/resto/\(restoId)")
    
    
    // trouver la référence de l'image
   
    refResto.observeSingleEventOfType(.Value, withBlock: { snapshot in
        if let myImageId = snapshot.value.objectForKey("imageId") as? String {
            let refImage = Firebase(url: "\(firebaseUrl)/data/images/\(myImageId)")
            refImage.removeValue()
        }
        refResto.removeValue()
        // simpleAlert("Suppression", message: "resto \(restoId) supprimé", controller: viewController)
        completionHandler(success: true)
    })
}
