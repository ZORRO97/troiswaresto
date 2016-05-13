//
//  MainViewController.swift
//  troiswaresto
//
//  Created by etudiant-11 on 25/04/2016.
//  Copyright © 2016 francois. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController {
    
    @IBOutlet var testImageView : UIImageView!
    @IBOutlet var statusLabel : UILabel!
    @IBOutlet var connectButton : UIButton!
    
    var restos = [Resto]()
    var user : User!
    var myCoreDataUser: CoreDataUser!
    var myCoreDataReviews = [CoreDataReview]()
    
    @IBAction func connectButtonPressed(){
        
        if myCoreDataUser != nil {
            // CoreDataHelper.deleteOneUser()
            user.removeUserInCoreData(myCoreDataUser)
            FirebaseHelper.disconnectFirebaseUser()
            NSUserDefaults.resetStandardUserDefaults()
            myCoreDataUser = nil
            user = nil
            updateUserDisplay()
        } else {
            logDebug("relier à la connexion")
            self.performSegueWithIdentifier("tologin", sender: self)
        }
    }
    
    func updateUserDisplay(){
        
        if myCoreDataUser != nil {
            statusLabel.text = "connecté en tant que \(user.nickname)"
            connectButton.setTitle("se déconnecter", forState: .Normal)
        } else {
            connectButton.setTitle("Connexion", forState: .Normal)
            statusLabel.text = "anonyme"
        }
    }
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "torestos" {
            let myDestination : RestosViewController = segue.destinationViewController as! RestosViewController
            myDestination.restos = restos
        }
    }
 */

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // testImageView.image = UIImage(named: "imageen")
        
        // syntaxe avec l'extension
        let myString = "main.hello".translate
        NSLog(myString)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let now = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .ShortStyle
        logDebug(dateFormatter.stringFromDate(now))
        let abitlater = NSDate()
        dateFormatter.stringFromDate(abitlater)
        let toto : NSTimeInterval = abitlater.timeIntervalSinceDate(now)
        logDebug("intervalle de temps \(toto)")
        
        
        user = getUserFromUserDefaults()
        myCoreDataUser = CoreDataHelper.fetchOneUser()
        updateUserDisplay()
        if myCoreDataUser != nil {
        if let myReviews = myCoreDataUser.review as? Set<CoreDataReview>  {
            for review in myReviews {
                self.myCoreDataReviews.append(review)
            }
        }
            
        // let myCoreDataReviews = CoreDataHelper.fetchReviews()
        logDebug("les reviews \(myCoreDataReviews)")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

