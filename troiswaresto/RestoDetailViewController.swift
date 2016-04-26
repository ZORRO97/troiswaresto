//
//  RestoDetailViewController.swift
//  troiswaresto
//
//  Created by etudiant-11 on 25/04/2016.
//  Copyright © 2016 francois. All rights reserved.
//

import UIKit

class RestoDetailViewController: UIViewController {
    
    @IBOutlet var restoImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ratingLabel : UILabel!
    @IBOutlet var priceLabel : UILabel!
    @IBOutlet var distanceLabel : UILabel!
    @IBOutlet var addressLabel : UILabel!
    @IBOutlet var descriptionTextView : UITextView!
    @IBOutlet var chatButton: UIButton!
    @IBOutlet var mapButton: UIButton!
    
    @IBOutlet var reviewTableView: UITableView!
    
    
    var resto : Resto!
    var restos = [Resto]()
    var reviews = [Review]()
    
    @IBAction func backButtonPressed(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func initReview(){
        reviews.append(Review(rating: 2, restoId: 1))
        reviews.append(Review(rating: 3, restoId: 1))
        reviews[0].nickname = "Penible22"
        reviews[0].description = "Lamentable n'y allez pas !"
        reviews[1].nickname = "Mecene34"
        reviews[1].description = "Super ambiance décalée"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addComment" {
            let mydestination : CommentViewController = segue.destinationViewController as! CommentViewController
            mydestination.resto = resto
            mydestination.reviews = reviews
            mydestination.restoDetailViewController = self
            
        }
        if segue.identifier == "tomapone" {
            let mydestination : MapViewController = segue.destinationViewController as! MapViewController
            mydestination.selectedResto = resto
            
            mydestination.allRestos = restos
           // mydestination.restoDetailViewController = self        
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // reviewTableView.tableHeaderView. modifier titre du tableau à chercher
        initReview()
        
        
        print("resto name \(resto.name)")
        nameLabel.text = resto.name
        if let restoImage = resto.image {
            restoImageView.image = restoImage
        } else {
            restoImageView.image = UIImage(named: "icon152")
        }
        ratingLabel.text = "\(resto.rating)"
        // priceRange
        if let myPriceRange = resto.priceRange {
            priceLabel.text = "\(myPriceRange)"
        }
        distanceLabel.text = "\(resto.distance) m"
        addressLabel.text = resto.address
        
        if let myDescription = resto.description {
            descriptionTextView.text = myDescription
        } else {
            descriptionTextView.text = "à remplir"
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        reviewTableView.reloadData()
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

// MARK: - TableView

extension RestoDetailViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // A modifier, retourner le nombre de ligne dans la section
        
        return reviews.count + 1
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == reviews.count {
            let cell = tableView.dequeueReusableCellWithIdentifier("AddCell", forIndexPath: indexPath) as! AddCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("ReviewCell", forIndexPath: indexPath) as! ReviewCell
            // Ajouter la logique d'affichage du texte dans la cellule de la TableView
            // la variable indexpath.row indique la ligne selectionnée
            // on accède aux IBOutlet de la cellule avec par exemple : cell.name =
            
            cell.nicknameLabel.text  = reviews[indexPath.row].nickname
            
            if let myDescription = reviews[indexPath.row].description {
                cell.textDescriptionLabel.text = "\(myDescription)"
            } else {
                cell.textDescriptionLabel.text = "pas de commentaire"
            }
            
            cell.rateLabel.text = "4 étoiles"
            return cell
        }
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedRow = indexPath.row
        if selectedRow == reviews.count {
            self.performSegueWithIdentifier("addComment", sender: self)
        }
        //faire quelque chose avec selectedRow
        NSLog("Ligne sélectionnée \(selectedRow)")
        
        
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Avis"
    }
    
    }