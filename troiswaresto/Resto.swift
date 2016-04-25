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
    
    let restoId:Int
    var name: String
    var position : CLLocation
    var description : String?
    var reviews = [Review]()
    var rating: Double {
        return 0
    }
    var address: String {
        return "inconnue"
    }
    var image: UIImage?
    var priceRange : PriceRange?
    var distance: CLLocationDistance {
        return 0
    }
    
    
    
    init (restoId:Int,name: String, position: CLLocation){
        self.restoId = restoId
        self.name = name
        self.position = position
        
    }
    
}

enum PriceRange {
    case Cheap
    case Normal
    case Expensive
}