//
//  Model.swift
//  troiswaresto
//
//  Created by etudiant-11 on 26/04/2016.
//  Copyright © 2016 francois. All rights reserved.
//

import Foundation
import MapKit

enum ScreenType {
    case Home
    case Work
    case Geoloc
}

enum PinType {
    case FavoriteResto
    case StandardResto
    case Home
    case Work
}

class Pin: NSObject, MKAnnotation {
    var title: String? {
        if let myTitle = self.resto.name as String! {
            return myTitle
        } else {
            return nil
        }
    }
    // let location: CLLocation
    let pinType: PinType
    
    var image: UIImage {
        let label:String
        switch self.pinType {
            
        case .FavoriteResto : label = "station_orange"
        case .StandardResto : label = "station_grise"
        case .Home : label = "home"
        case .Work : label = "work"
            
        }
        if let myImage = UIImage(named: label) {
            return myImage
        } else {
            return UIImage(named : "plus")!
        }
        
    }
    var resto: Resto
    
    init(resto : Resto, pinType: PinType) {
        
        self.resto = resto
        // self.location = location
        self.pinType = pinType
        // self.image = image
        super.init()
    }
    
    var coordinate : CLLocationCoordinate2D {
        return self.resto.position.coordinate
    }
    
    //nécessaire si on ne veut pas de subtitle
    var subtitle: String? {
        return ""
    }
}
