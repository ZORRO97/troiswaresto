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
    
    @IBAction func connectButtonPressed(){
        
        if user != nil {
            FirebaseHelper.disconnectFirebaseUser()

            user = nil
            updateUserDisplay()
        } else {
            logDebug("relier à la connexion")
            self.performSegueWithIdentifier("tologin", sender: self)
        }
    }
    
    func updateUserDisplay(){
        
        if user != nil {
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
        
        
        // Do any additional setup after loading the view, typically from a nib.
        /*
        let myRootRef = Firebase(url:"https://sweltering-heat-2058.firebaseio.com")
        
        myRootRef.observeEventType(.Value, withBlock: {
            snapshot in
            logDebug("back from request")
            // logDebug("\(snapshot.key) -> \(snapshot.value)")
        })
         */
        
                /*
        // image de test avec une pretty woman
        let myImage = getImageFromURL("https://pixabay.com/static/uploads/photo/2016/03/23/08/15/beautiful-1274345__340.jpg")
        let imageData: NSData = UIImagePNGRepresentation(myImage!)!
        
        uploadDataToFirebase(imageData,
                             completion: {(imageId) in
                                getImageDataFromFirebase(imageId!, completionHandler:
                                    {(data) in
                                        let myImage = UIImage(data: data! ,scale:1.0)
                                        self.testImageView.image = myImage
                                    }
                                )
        })
        */
        
        
        
        testImageView.image = UIImage(named: "imageen")
        // let myString = NSLocalizedString("main.hello", comment: "pour dire bonjour")
        // syntaxe avec l'extension
        let myString = "main.hello".translate
        NSLog(myString)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        user = getUserFromUserDefaults()
        updateUserDisplay()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

