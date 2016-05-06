//
//  LoginViewController.swift
//  troiswaresto
//
//  Created by etudiant-11 on 06/05/2016.
//  Copyright © 2016 francois. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var emailTextField : UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var okButton: UIButton!
    
    @IBAction func okButtonPressed(){
        let myEmail = emailTextField.text
        let myPassword = passwordTextField.text
        if myEmail?.characters.count > 4 && myPassword?.characters.count > 3 {
            // tester si l'identification est correcte
            // si oui relier au main
            performSegueWithIdentifier("tomainconnected", sender: self)
        }
    }
    
    // action effectuée lorsqu'on tape en dehors de la zone de saisie
    @IBAction func viewTaped(){
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
       
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
        animateViewMoving(true, moveValue: 150)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        animateViewMoving(false, moveValue: 150)
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
