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

func isIpad()->Bool {
    return UIDevice.currentDevice().userInterfaceIdiom == .Pad
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


// MARK: - simpleAlert
// version de base
func simpleAlert(title: String, message: String, controller : UIViewController){
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    
    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil) )
    
    controller.presentViewController(alert, animated: true, completion: nil)
    
}

// alert avec closure en paramètre pour l'action positive
func simpleAlert(title: String, message: String, controller : UIViewController, positiveAction :()->()){
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    
    alert.addAction(UIAlertAction(title: "Activer", style: .Default) { (UIAlertAction) in
        positiveAction()
        })
    // alert.addAction(UIAlertAction(title: "Annuler", style: .Default, handler: nil ))
    controller.presentViewController(alert, animated: true, completion: nil)
    
}

// alert avec closures en paramètres positiveAction et negativeAction
func simpleAlert(title: String, message: String, controller : UIViewController, positiveAction :()->(), negativeAction:()->()){
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (UIAlertAction) in
        positiveAction()
        })
    
    alert.addAction(UIAlertAction(title: "Annuler", style: UIAlertActionStyle.Default) { (UIAlertAction) in
        negativeAction()
        })
    
    controller.presentViewController(alert, animated: true, completion: nil)
    
}

func affichageDouble(number : Double)-> String {
    return String(Int(round(number)))
}

extension String {
    var translate :String {
        return NSLocalizedString(self, comment: "")
    }
    
    
    func trimBefore(needle: String)->String {
        var output = self
        if let position = self.rangeOfString(needle) {
            output.removeRange(self.startIndex..<position.endIndex)
        }
        return output
    }
}

/**
 * Renvoi une String avec la date en UTC
 */
extension NSDate {
    var absoluteDateToString : String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = NSTimeZone(name: "UTC")
        return formatter.stringFromDate(self)
    }
    
    var reductDateToString : String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = NSTimeZone(name: "UTC")
        return formatter.stringFromDate(self)
    }
}

extension String {
    var stringToDate : NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        /*find out and place date format from http://userguide.icu-project.org/formatparse/datetime*/
        let myDate = dateFormatter.dateFromString(self)
        return myDate!
    }
}
/*
// NSNotification


// à mettre à l'écouteur
NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(notificationReceived), name: "reviewsubmitted", object: nil)

// http://stackoverflow.com/questions/24049020/nsnotificationcenter-addobserver-in-swift
func notificationReceived(notification: NSNotification) {
    logWarning("Notification received from WelcomeViewController")
    
    if notification.userInfo != nil {
        if let myRating = notification.userInfo!["rating"] as? Double {
            logWarning("and the rating was:\(myRating)")
        }
        
        if let message = notification.userInfo!["message"] as? Double {
            logWarning("and the message was:\(message)")
        }
    }
}



// Pour envoyer la notification
NSNotificationCenter.defaultCenter().postNotificationName("reviewsubmitted", object: nil, userInfo: ["rating" : myReview.rating, "message" : 998])

*/
/*
enum ToastStyle {
    case FromTop
    case FromBottom
}

func makeToast(myview: UIView, message: String, offset: CGFloat, withStyle toastStyle:ToastStyle ) {
    let height: CGFloat = 40
    let waitingTime = 2.0
    
    var startPosition = CGPoint()
    var middlePosition = CGPoint()
    
    switch toastStyle {
    case .FromTop:
        startPosition = CGPoint(x: 10, y: -height)
        middlePosition = CGPoint(x: 10, y: offset)
    case .FromBottom:
        startPosition = CGPoint(x: 10, y: realScreenHeight())
        middlePosition = CGPoint(x: 10, y: realScreenHeight() - offset - height)
        
    }
    let myToastView = UIView(frame: CGRectMake(startPosition.x, startPosition.y, realScreenWidth() - 20, height) )
    
    myToastView.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
    
    let myLabel = UILabel(frame: CGRectMake(2, 2, realScreenWidth() - 20 - 4, height - 4))
    myLabel.text = message
    myLabel.textAlignment = NSTextAlignment.Center
    myLabel.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
    
    myToastView.addSubview(myLabel)
    
    myview.addSubview(myToastView)
    myview.bringSubviewToFront(myToastView)
    
    UIView.animateWithDuration(1, delay: 0, options: [], animations: {
        myToastView.frame = CGRectMake(middlePosition.x, middlePosition.y, realScreenWidth() - 20, height)
        }, completion: nil)
    
    UIView.animateWithDuration(1, delay: waitingTime, options: [], animations: {
        myToastView.frame = CGRectMake(startPosition.x, startPosition.y, realScreenWidth() - 20, height)
        }, completion: {(Bool) in
            myToastView.removeFromSuperview()
    })
}

func makeToast(myview: UIView, message: String) {
    makeToast(myview, message: message, offset: 10, withStyle: .FromBottom)
}
 */
