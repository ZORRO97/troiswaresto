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

class Resto {
    
    let restoId:String
    var name: String
    var position : CLLocation
    var description : String?
    var reviews = [Review]()
    var rating: Double {
        return 0
    }
    var address: String {
        return "120 rue des poissonniers 75018 PARIS"
    }
    var image: UIImage?
    var priceRange : PriceRange?
    var distance: CLLocationDistance {
        return 0
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