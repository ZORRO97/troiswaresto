//
//  Utilities.swift
//  troiswaresto
//
//  Created by etudiant-11 on 25/04/2016.
//  Copyright © 2016 francois. All rights reserved.
//

import Foundation
import UIKit
let TESTVERSION = true

/**
 Calcule la position du soleil en fonction de l'avancement
 - parameters:
 - centerPoint : Le point du centre de la rotation
 - rayon : Le rayon de la rotation
 - completionRate : Le dégré d'avancement de la rotation. 0 pour le départ, 1 pour l'arrivée.
 */
func getSunPosition (centerPoint : CGPoint, rayon : CGFloat, completionRate : Double)->CGPoint {
    var output = CGPoint()
    
    let angle = M_PI * (1 - completionRate)
    output.x = centerPoint.x + rayon * CGFloat(cos(angle))
    output.y = centerPoint.y - rayon * CGFloat(sin(angle))
    
    return output
}

func logUserDefaultsWithFilter(needle: String?) {
    print("******    User Defaults  ******")
    for (key, value) in NSUserDefaults.standardUserDefaults().dictionaryRepresentation() {
        
        if (needle != nil) {
            if key.rangeOfString(needle!) != nil {
                NSLog("key=\(key) value=\(value)\n")
            }
        } else {
            logDebug("key=\(key) value=\(value)\n")
        }
    }
}

func logDebug (myString: String) {
    if (TESTVERSION) {
        NSLog("debug:" + myString)
    }
}

func logWarning (myString: String) {
    NSLog("⚡️warning⚡️:" + myString)
}

func logError (myString: String) {
    NSLog("💔error💔:" + myString)
}

func isLandscape()->Bool {
    let orientation =  UIApplication.sharedApplication().statusBarOrientation
    
    return ((orientation == UIInterfaceOrientation.LandscapeLeft ) || (orientation == UIInterfaceOrientation.LandscapeRight))
}



func deviceScreenHeight()->Float {// renvoie la  hauteur du device, independamment de l'orientation
    if isLandscape() {
        //  println("returning width instead of height")
        return Float(UIScreen.mainScreen().bounds.size.width)
    } else {
        return Float(UIScreen.mainScreen().bounds.size.height)
    }
}

func getDevice ()-> String {//retourne le nom du modèle basé sur la hauteur
    #if os(iOS)
        let deviceHeight = deviceScreenHeight()
        
        //   println("realheight=\(deviceHeight)")
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
            return "iPad"
        }
        else {
            switch deviceHeight {
            case 480:
                return "iPhone4"
            case 568:
                return "iPhone5"
            case 667:
                return "iPhone6"
            case 736:
                return "iPhone6plus"
            default:
                return "unknown"
            }
        }
    #else
        return "AppleTV"
    #endif
}


func getUserLanguage()->String {//from defined languages in localisation, "en" as default
    let displayNameString = NSLocale.preferredLanguages()[0]
    var output = "en"
    
    logDebug("langageString=\(displayNameString)")
    
    if (displayNameString.rangeOfString("fr") != nil) { output = "fr"  }
    if (displayNameString.rangeOfString("es") != nil) { output = "es"  }
    if (displayNameString.rangeOfString("de") != nil) { output = "de"  }
    if (displayNameString.rangeOfString("it") != nil) { output = "it"  }
    if (displayNameString.rangeOfString("Hans") != nil) { output = "zh" }
    if (displayNameString.rangeOfString("pt") != nil) { output = "pt" }
    if (displayNameString.rangeOfString("ko") != nil) { output = "ko" }
    if (displayNameString.rangeOfString("ja") != nil) { output = "ja" }
    if (displayNameString.rangeOfString("en-GB") != nil) { output = "en-GB" }
    
    return output
}

/**
 Récupère une image dans une url donnée
 
 Fonction **synchrone**.
 
 Renvoie nil en cas d'erreur
 */

func getImageFromURL(fileURL: String)->UIImage? {
    print("loading remote image:\(fileURL)")
    
    if let myurl = NSURL(string: fileURL) {
        if let mydata = NSData(contentsOfURL: myurl) {
            if let result = UIImage(data: mydata) {
                return result
            } else {
                logWarning("pb pour convertir en UIImage pour fileUrl=\(fileURL)")
                return nil
            }
        } else {
            logWarning("pb pour convertir en NSData")
            return nil
        }
    } else {
        logWarning("error: not a valid url for:\(fileURL)")
        return nil
    }
}

// TODO: ajouter le champ "fileUrl" dans Firebase
// récupérer cette valeur dans la requête Alamofire
// utiliser cette fonction pour récupérer de façon synchrone l'image du restaurant et l'ajouter à l'objet resto