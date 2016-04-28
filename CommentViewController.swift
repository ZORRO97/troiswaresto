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
    
    @IBAction func backButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func validReviewPressed(){
        print("on valide la nouvelle review")
        print(commentTextField.text)
        print("slider \(ratingSlider.value)")
        // enregistrer les nouvelles données
        if let myText = commentTextField.text {
            let myReview = Review(rating: Double(Int(ratingSlider.value)))
            myReview.description = myText
            myReview.nickname = "critique xxx"
            resto.reviews.append(myReview)
            resto.addReviewInCloud(myReview)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func valueSliderChanged(){
        let note = Int(ratingSlider.value)
        ratingLabel.text = "Note \(note)/20"
    }
    
    func afficheResto(){
        nameLabel.text = resto.name
        restoImageView.image = UIImage(named: "icon152")
        nicknameLabel.text = "Avis de critiqueN"
        commentTextField.text = ""
     }

    override func viewDidLoad() {
        super.viewDidLoad()

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

}
