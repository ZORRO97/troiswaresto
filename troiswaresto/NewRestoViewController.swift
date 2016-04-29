//
//  NewRestoViewController.swift
//  troiswaresto
//
//  Created by etudiant-11 on 28/04/2016.
//  Copyright © 2016 francois. All rights reserved.
//

import UIKit

class NewRestoViewController: UIViewController {
    
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var cheapButton: UIButton!
    @IBOutlet var normalButton: UIButton!
    @IBOutlet var expensiveButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    var restos: [Resto]!
    var newResto : Resto!
    
    // action effectuée lorsqu'on tape en dehors de la zone de saisie
    @IBAction func viewTaped(){
    
        nameTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
        
    }
    
    @IBAction func backButtonPressed(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func takePhotoPressed(){
        print("photo à prendre")
    }
    
    @IBAction func saveRestoValidate(){
        NSLog("on va le sauver ce resto")
    }
    
    @IBAction func starPricerangePressed(sender: AnyObject){
        switch sender.tag {
        case 0 : print("resto cheap")
            //cheapButton.setBackgroundImage(UIImage. , forState: .Focused)
                // UIControlState.Focused
        

            
        case 1 : print("resto normal")
        case 2 : print("resto expensive")
        default: break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
