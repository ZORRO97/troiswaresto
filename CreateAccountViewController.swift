//
//  CreateAccountViewController.swift
//  troiswaresto
//
//  Created by etudiant-11 on 06/05/2016.
//  Copyright © 2016 francois. All rights reserved.
//

import UIKit


class CreateAccountViewController: UIViewController {
    
    @IBOutlet var emailTextField : UITextField!
    @IBOutlet var passwordTextField : UITextField!
    @IBOutlet var password2TextField : UITextField!
    @IBOutlet var nicknameTextField : UITextField!
    @IBOutlet var okButton: UIButton!
    
    @IBAction func okButtonPressed(){
        let myEmail = emailTextField.text
        let myPassword = passwordTextField.text
        let myPasswordAgain = password2TextField.text
        let myNickname = nicknameTextField.text
        if myPassword == myPasswordAgain && myEmail?.characters.count > 4 && myNickname?.characters.count > 2 && myPassword == myPasswordAgain{
            // créer le compte
            FirebaseHelper.createFirebaseUser(myEmail!, password: myPassword!, nickname : myNickname!)
            
            // rediriger vers Main
            self.performSegueWithIdentifier("tomainnewaccount", sender: self)
        }
    }
    
    // action effectuée lorsqu'on tape en dehors de la zone de saisie
    @IBAction func viewTaped(){
        endOnExit()

    }
    
    @IBAction func endOnExit(){
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        password2TextField.resignFirstResponder()
        nicknameTextField.resignFirstResponder()
    }
    
    @IBAction func backButtonPressed(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Remonter la vue avec le clavier
    
    func textFieldDidBeginEditing(textField: UITextField) {
        animateViewMoving(true, moveValue: 100)
        logDebug("edit did begin")
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        animateViewMoving(false, moveValue: 100)
        logDebug("edit did end")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
