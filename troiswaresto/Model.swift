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
import Firebase


enum ScreenType {
    case AddResto
    case AllRestos
    case OneResto
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

func getDetailReviews(rewJson: JSON)->[Review] {
    var output = [Review]()
    for (_,dJson):(String,JSON) in rewJson {
        if let myRating = dJson["rating"].double {
            
        
         let myReview = Review(rating: myRating)
            if let myDescription = dJson["description"].string {
                myReview.description = myDescription
            }
            if let myNickname = dJson["nickname"].string {
                myReview.nickname = myNickname
            }
            output.append(myReview)
        }
        
    }
    return output
}
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
                
                // print(myResto)
                
                for (key,subJson):(String, JSON) in myResto {
                    // print(key)
                    // print(subJson["name"])
                    //Do something you want
                    if let myName = subJson["name"].string , let myLatitude = subJson["position"]["lat"].double, let myLongitude = subJson["position"]["long"].double {
                        let myResto = Resto(restoId: key, name: myName , position: CLLocation(latitude: CLLocationDegrees(myLatitude), longitude: CLLocationDegrees(myLongitude) ))
                        
                        for (rkey,detJson):(String, JSON) in subJson {
                            switch rkey {
                                case "description": myResto.description = detJson.string
                                case "priceRange":
                                    if let priceRange = detJson.int {
                                        myResto.priceRange = PriceRange(rawValue: priceRange)
                                    }
                            case "fileURL" :
                                if let myURL = detJson.string {
                                    myResto.image = getImageFromURL(myURL)
                                }
                            case "reviews":
                                    myResto.reviews = getDetailReviews(detJson)
                            default:
                                // NSLog("clé \(rkey) non traitée")
                                break
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

func getRestosInfoFirebase (tableview: UITableView, completion:(restos : [Resto])->Void)  {
    //  logDebug("launch resto request")
    
    
    logDebug("début de getRestosInfo")
    
    let restosRef = Firebase(url:"\(firebaseUrl)/data/resto")
 //   restosRef.observeSingleEventOfType(.Value, withBlock: {
    restosRef.observeEventType(.Value, withBlock: {
        snapshot in
        var output = [Resto]()
        //  logDebug("\(snapshot)")
        
        for item in snapshot.children.allObjects as! [FDataSnapshot] {
            
            if let name = item.value.objectForKey("name") as? String,
            let myPosition = item.value.objectForKey("position") as? [String : Double]
             {
                // logDebug("name=\(name) position \(myPosition) for key=\(item.key) ")
                if let myLatitude = myPosition["lat"], let myLongitude = myPosition["long"] {
                    let myResto = Resto(restoId: item.key, name: name, position: CLLocation(latitude: CLLocationDegrees(myLatitude), longitude: CLLocationDegrees(myLongitude)))
                    if let myDescription = item.value.objectForKey("description") as? String {
                        myResto.description = myDescription
                    }
                    if let myPriceRange = item.value.objectForKey("priceRange") as? Int {
                        myResto.priceRange = PriceRange(rawValue: myPriceRange)
                    }
                    //if let myFileUrl = item.value.objectForKey("fileURL") as? String {
                    //    myResto.image = getImageFromURL(myFileUrl)
                    //}
                    
                    if let myAdress = item.value.objectForKey("address") as? String {
                        myResto.address = myAdress
                    }
                    
                    if let myImageId = item.value.objectForKey("imageId")  as? String {
                        getUIImageFromImageId(myImageId){ (imageUI) in
                            myResto.image = imageUI
                            NSLog("image chargée \(myImageId)")
                            tableview.reloadData()
                        }
                    }
                    
                    if let myReviews = item.childSnapshotForPath("reviews") {
                        myResto.reviews = hydrateReviews(myReviews)
                    }
                    
                    output.append(myResto)
                }
            } else {
                logDebug("nom non accessible")
            }
            
        }
        completion(restos: output)
        
    })
    
}

func hydrateReviews(reviewsSnapshot : FDataSnapshot)->[Review] {
    var mesReviews = [Review]()
    for item in reviewsSnapshot.children.allObjects as! [FDataSnapshot] {
        if let myRating = item.value.objectForKey("rating") as? Double {
            
            
            let myReview = Review(rating: myRating)
            if let myDescription = item.value.objectForKey("description") as? String {
                myReview.description = myDescription
            }
            if let myNickname =  item.value.objectForKey("nickname") as? String {
                myReview.nickname = myNickname
            }
            if let myDateString = item.value.objectForKey("date") as? String {
                myReview.date = myDateString.stringToDate
            }
            mesReviews.append(myReview)
        }

    }
    return mesReviews
}

func textePriceRange(priceRange: PriceRange?)->String {
    
    var output:String
    if let myPriceRange = priceRange {
        switch myPriceRange {
            case .Cheap : output = "€"
            case .Normal : output = "€€"
            case .Expensive : output = "€€€"
        }
    } else {
        output = "Inconnu"
    }
    return output
}

func getAdressFromLocation (location : CLLocation, completion:(String)->Void ) {
    CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
        var output = ""
        if (error != nil) {
            logError("Reverse geocoder failed with error" + error!.localizedDescription)
            output = "error"
        } else {
            logDebug("retour geocoder")
            if placemarks!.count > 0 {
                let pm = placemarks![0] as CLPlacemark
                if pm.thoroughfare != nil && pm.subThoroughfare != nil {
                    output =  pm.subThoroughfare! + " " + pm.thoroughfare!
                } else {
                    output = ""
                }
            } else {
                output = "error"
            }
        }
        logDebug("output = \(output)")
        completion(output)
    })
}

//Pour convertir de la data en UIImage
// let myImage = UIImage(data:myData ,scale:1.0)

//Pour convertir une UIImage en Data
//Google is your friend

//et les deux fonctions pour écrire et lire de la NSData dans Firebase
//à mettre dans Model.swift

// http://richardbakare.com/thursday-tech-tip-firebase-images/
func uploadDataToFirebase(myData : NSData, completion: (imageId : String?)->Void ) {
    let imageString = myData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
    
    let myRef = Firebase(url:firebaseUrl).childByAppendingPath("data/images").childByAutoId()
    
    myRef.setValue(["imagedata" : imageString], withCompletionBlock: {(error, ref) in
        
        if error == nil {
            completion(imageId: myRef.key)
        } else {
            completion(imageId: nil)
        }
    })
}

/*
func uploadImageToFirebase(myImage : UIImage, completion: (imageId : String?)->Void ) {
    
    let imageData: NSData = UIImagePNGRepresentation(myImage)!
    let imageString = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
    
    let myRef = Firebase(url:firebaseUrl).childByAppendingPath("data/images").childByAutoId()
    
    myRef.setValue(["imagedata" : imageString], withCompletionBlock: {(error, ref) in
        
        if error == nil {
            completion(imageId: myRef.key)
        } else {
            completion(imageId: nil)
        }
    })
}
*/


// fonction pour réduire une image d'un facteur entier
// http://nshipster.com/image-resizing/
func reduceImage(image : UIImage, factor : Int)-> UIImage {
    let size = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(1 / CGFloat(factor), 1 / CGFloat(factor)))
    let hasAlpha = false
    let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
    
    UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
    image.drawInRect(CGRect(origin: CGPointZero, size: size))
    
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return scaledImage
}



// début de la fonction
// http://richardbakare.com/thursday-tech-tip-firebase-images/
/* func uploadImageToFirebase(image: UIImage, completion: (imageId : String?)->Void ) {
    
    //reduction de la taille de l'image si elle est trop grande
    var resizedImage = image
    if image.size.width > 2400 {
        logWarning("initial size=\(image.size)")
        resizedImage = reduceImage(image, factor: 2)
        logWarning("reduced size=\(resizedImage.size)")
    }
}
 */

func uploadImageToFirebase(image: UIImage, completion: (imageId : String?)->Void ) {
    
    
    //reduction de la taille de l'image si elle est trop grande
    var resizedImage = image
    if image.size.width > 2400 {
        logWarning("initial size=\(image.size)")
        resizedImage = reduceImage(image, factor: 2)
        logWarning("reduced size=\(resizedImage.size)")
    }
    
    if let myData: NSData = UIImageJPEGRepresentation(resizedImage, 0.5) {
        let imageString = myData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        let myRef = Firebase(url:firebaseUrl).childByAppendingPath("data/images").childByAutoId()
        
        //TODO: faire un test ici pour calculer la taille en octets de imageString et vérifier moins de 10 Mo
        myRef.setValue(["imagedata" : imageString], withCompletionBlock: {(error, ref) in
            
            if error == nil {
                completion(imageId: myRef.key)
            } else {
                logError("error to save image in Firebase:\(error.description)")
                completion(imageId: nil)
            }
        })
    } else {
        completion(imageId: nil)
        logError("error to save image in Firebase, data not good")
    }
}




func getImageDataFromFirebase(imageId : String, completionHandler:(data : NSData?)->Void ) {
    let myRef = Firebase(url:firebaseUrl).childByAppendingPath("data/images/\(imageId)")
    
    myRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
        if let myString = snapshot.value.objectForKey("imagedata") as? String {
            if let data = NSData(base64EncodedString: myString, options: NSDataBase64DecodingOptions(rawValue: 0)) {
                
                completionHandler(data: data)
            } else {
                completionHandler(data: nil)
            }
        }
    })
}

func getUIImageFromImageId(imageId : String, completionHandler : (imageUI: UIImage?)->Void){
    
    let myRef = Firebase(url:firebaseUrl).childByAppendingPath("data/images/\(imageId)")
    
    myRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
        if let myString = snapshot.value.objectForKey("imagedata") as? String {
            if let data = NSData(base64EncodedString: myString, options: NSDataBase64DecodingOptions(rawValue: 0)) {
                if let myImage = UIImage(data: data ,scale:1.0) {
                completionHandler(imageUI: myImage)
                } else {
                    completionHandler(imageUI: nil)
                }
                
            } else {
                completionHandler(imageUI: nil)
            }
        }
    })
}



