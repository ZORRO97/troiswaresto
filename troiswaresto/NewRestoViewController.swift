//
//  NewRestoViewController.swift
//  troiswaresto
//
//  Created by etudiant-11 on 28/04/2016.
//  Copyright © 2016 francois. All rights reserved.
//

import UIKit
import CoreLocation
import MobileCoreServices

class NewRestoViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var cheapButton: UIButton!
    @IBOutlet var normalButton: UIButton!
    @IBOutlet var expensiveButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var restoImageView: UIImageView!
    
    var restos: [Resto]!
    var newResto : Resto!
    var address: String = ""
    var position : CLLocation!
    var priceRange : PriceRange = .Normal
    
    // action effectuée lorsqu'on tape en dehors de la zone de saisie
    @IBAction func viewTaped(){
    
        nameTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
        
    }
    
    @IBAction func backButtonPressed(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func takePhotoPressed(){
        print("photo à prendre")
        let alert = UIAlertController(title: "Menu photo", message: "", preferredStyle: .ActionSheet )
        
        alert.addAction(UIAlertAction(title: "Prendre une photo", style: .Default) { (UIAlertAction) in
            NSLog("action positive")
            self.useCameraWithResto()
            })
        
        alert.addAction(UIAlertAction(title: "Camera Roll", style: .Default) { (UIAlertAction) in
                self.useCameraRoll()
            })
        
        alert.addAction(UIAlertAction(title: "Annuler", style: .Destructive) { (UIAlertAction) in
            NSLog("action négative")
            })
        
        self.presentViewController(alert, animated: true, completion: nil)
    
    }
    
    @IBAction func saveRestoValidate(){
        NSLog("on va le sauver ce resto")
        NSLog("tentative de sauvegarde pour nom \(nameTextField.text) description  \(descriptionTextView.text) adresse \(address) priceRange \(priceRange) position \(position)")
        
        addRestoInCloud(nameTextField.text!, address: address, position: position, description: descriptionTextView.text, priceRange: priceRange, image: restoImageView.image , completionhandler: { success in
            logWarning("on a enregistré this fucking resto")
            simpleAlert("Enregistrement nouveau resto", message: "" , controller: self, positiveAction: { _ in
                self.performSegueWithIdentifier("tomain", sender: self)
            })
        })
    }
    
    
    
    @IBAction func starPricerangePressed(sender: AnyObject){
        switch sender.tag {
        case 0 : print("resto cheap")
        cheapButton.selected = true
        normalButton.selected = false
        expensiveButton.selected = false
        priceRange = .Cheap
            
        case 1 : print("resto normal")
        cheapButton.selected = false
        normalButton.selected = true
        expensiveButton.selected = false
        priceRange = .Normal
            
        case 2 : print("resto expensive")
        cheapButton.selected = false
        normalButton.selected = false
        expensiveButton.selected = true
        priceRange = .Expensive
            
        default: break
        }
    }
    
    
    func useCameraWithResto() {
        
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.Camera) {
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true,
                                       completion: nil)
            //  newMedia = true
        }
    }
    
    // récupère une image dans le cameraRoll
    func useCameraRoll() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true,
                                       completion: nil)
            // newMedia = false
        }
    }
    
    // recupère une photo via le pickerController
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if mediaType == (kUTTypeImage as String) {
            
            // on récupère ici l'image
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            restoImageView.image = image
            
            //on pourrait faire d'autres choses
            
            /*
             if (newMedia == true) {
             UIImageWriteToSavedPhotosAlbum(image, self,
             "image:didFinishSavingWithError:contextInfo:", nil)
             } else if mediaType == (kUTTypeMovie as String) {
             // Code to support video here
             }
             */
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.text = ""
        addressLabel.text = address
        normalButton.selected = true
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Remonter la vue avec le clavier
    
     @IBAction func textFieldDidBeginEditing(textField: UITextField) {
     animateViewMoving(true, moveValue: 100)
     }
     
     @IBAction func textFieldDidEndEditing(textField: UITextField) {
     animateViewMoving(false, moveValue: 100)
     }
     
     func animateViewMoving (up:Bool, moveValue :CGFloat){
     let movementDuration:NSTimeInterval = 0.3
     let movement:CGFloat = ( up ? -moveValue : moveValue)
     UIView.beginAnimations( "animateView", context: nil)
     UIView.setAnimationBeginsFromCurrentState(true)
     UIView.setAnimationDuration(movementDuration )
     self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
     UIView.commitAnimations()
     }
    
    // MARK: -

}
