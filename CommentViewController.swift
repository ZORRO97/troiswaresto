//
//  CommentViewController.swift
//  troiswaresto
//
//  Created by etudiant-11 on 26/04/2016.
//  Copyright © 2016 francois. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var restoImageView: UIImageView!
    @IBOutlet var nicknameLabel : UILabel!
    @IBOutlet var commentTextField : UITextField!
    @IBOutlet var ratingSlider: UISlider!
    @IBOutlet var ratingLabel: UILabel!
   
    
    
    
    var resto: Resto!
    var reviews:[Review]!
    var restoDetailViewController: RestoDetailViewController!
    var user: User!
    var coreUser: CoreDataUser!
    
    
    @IBAction func validReviewPressed(){
        print("on valide la nouvelle review")
        print(commentTextField.text)
        print("slider \(ratingSlider.value)")
        // enregistrer les nouvelles données
        if let myText = commentTextField.text {
            let myReview = Review(rating: Double(Int(ratingSlider.value)))
            myReview.description = myText
            myReview.nickname = coreUser.nickname
            myReview.date = NSDate()
            
            simpleAlert("Confirmation", message: "Voulez vous valider cet avis ?", controller: self,
                        positiveAction: { _  in
                            
                            
                            
                            self.resto.addReviewInCloud(myReview) { (success) in
                                
                                if success {
                                    simpleAlert("INFORMATION", message: "Votre review a été enregistré", controller: self,
                                        positiveAction: {() in
                                            self.resto.reviews.append(myReview)
                                            myReview.persistReviewInCoreData(self.coreUser)
                                            self.navigationController?.popViewControllerAnimated(true)
                                    })
                                } else {
                                    simpleAlert("ALERTE", message: "Probleme de connexion avec la base de données", controller: self)
                                }
                                
                            }
                            
                },
                        negativeAction: {()->() in self.navigationController?.popViewControllerAnimated(true)}
            )
            
        }
    }
    
    
    @IBAction func valueSliderChanged(){
        let note = Int(ratingSlider.value)
        ratingLabel.text = "Note \(note)/20"
    }
    
    // action effectuée lorsqu'on tape en dehors de la zone de saisie
    @IBAction func viewTaped(){
        commentTextField.resignFirstResponder() //
        
    }
    
    
       func afficheResto(){
        nameLabel.text = resto.name
        if let restoImage = resto.image {
            restoImageView.image = restoImage
        } else {
            restoImageView.image = UIImage(named: "icon152")
        }
        
        nicknameLabel.text = "\(user.nickname)"
        commentTextField.text = ""
     }

    override func viewDidLoad() {
        super.viewDidLoad()
        user = getUserFromUserDefaults()

        // Do any additional setup after loading the view.
        
    
        afficheResto()
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
    
     func textFieldDidBeginEditing(textField: UITextField) {
     animateViewMoving(true, moveValue: 100)
     }
     
     func textFieldDidEndEditing(textField: UITextField) {
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
