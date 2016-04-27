//
//  Model.swift
//  troiswaresto
//
//  Created by etudiant-11 on 26/04/2016.
//  Copyright © 2016 francois. All rights reserved.
//

import Foundation
import MapKit
import Alamofire
import SwiftyJSON


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

//func getRestosInfo(){
    
//}

func getRestosInfo(completionHandler: (allRestos :[Resto])->()){
    // URL spécifique de Firebase
    let urlString = "\(firebaseUrl)/data.json"
    //var output = [Resto]()
    var allRestos = [Resto]()
    
    NSLog("debut de getRestosInfo")
    
    Alamofire.request(.GET, urlString, parameters : nil)
        .response { (request, response, data, error) in
            NSLog("Résultat de la requête reçu")
            if (error == nil && data != nil) {
                
                
                let json = JSON(data: data!) // tableau de json
                
                let myResto = json["resto"]
                
                print(myResto)
                
                for (key,subJson):(String, JSON) in myResto {
                    print(key)
                    print(subJson["name"])
                    //Do something you want
                    if let myName = subJson["name"].string , let myLatitude = subJson["position"]["lat"].double, let myLongitude = subJson["position"]["long"].double {
                        let myResto = Resto(restoId: key, name: myName , position: CLLocation(latitude: CLLocationDegrees(myLatitude), longitude: CLLocationDegrees(myLongitude) ))
                        if let myDescription = subJson["description"].string {
                            myResto.description = myDescription
                        }
                        
                        if let priceRange = subJson["priceRange"].int {
                            myResto.priceRange = PriceRange(rawValue: priceRange)
                        }
                        if  subJson["reviews"] != nil {
                            for review in subJson["reviews"] {
                                if let myRating = review["rating"].double {
                                    let myReview = Review(rating: myRating, restoId: key)
                                    if let myReviewDescription = review["description"].string {
                                        myReview.description = myReviewDescription
                                    }
                                }
                            }
                        }
                        
                        allRestos.append(myResto)
                    }
                }
                               completionHandler(allRestos: allRestos)
            } else {
                NSLog("error in GetSimpleResto=\(error)")
            }
            
            NSLog("Fin du traitement de la requête")        }
    NSLog("fonction getRestosInfo terminée")
}

func textePriceRange(priceRange: PriceRange?)->String {
    
    var output:String
    if let myPriceRange = priceRange {
        switch myPriceRange {
            case .Cheap : output = "Bon Marché"
            case .Normal : output = "Normal"
            case .Expensive : output = "très cher"
        }
    } else {
        output = "Inconnu"
    }
    return output
}
