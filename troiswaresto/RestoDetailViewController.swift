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
    // @IBOutlet var ratingLabel : UILabel!
    @IBOutlet var star1ImageView: UIImageView!
    @IBOutlet var star2ImageView: UIImageView!
    @IBOutlet var star3ImageView: UIImageView!
    @IBOutlet var star4ImageView: UIImageView!
    @IBOutlet var star5ImageView: UIImageView!
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
    var coreUser : CoreDataUser!
    
    @IBAction func backButtonPressed(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func initReview(){
        reviews = self.resto.reviews
        // en fonction de la valeur du rating afficher plus ou moins d'étoiles
        if let myRating = self.resto.rating {
            let nbStars = Int(round(myRating / 4))
            if nbStars == 5 {
                star5ImageView.image = UIImage(named: "fleche_pleine")
            }
            if nbStars >= 4 {
                star4ImageView.image = UIImage(named: "fleche_pleine")
            }
            if nbStars >= 3 {
                star3ImageView.image = UIImage(named: "fleche_pleine")
            }
            if nbStars >= 2 {
                star2ImageView.image = UIImage(named: "fleche_pleine")
            }
            if nbStars >= 1 {
                star1ImageView.image = UIImage(named: "fleche_pleine")
            }
        }
        
        
        
       /* reviews.append(Review(rating: 2, restoId: 1))
        reviews.append(Review(rating: 3, restoId: 1))
        reviews[0].nickname = "Penible22"
        reviews[0].description = "Lamentable n'y allez pas !"
        reviews[1].nickname = "Mecene34"
        reviews[1].description = "Super ambiance décalée"
    */
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addComment" {
            let mydestination : CommentViewController = segue.destinationViewController as! CommentViewController
            mydestination.resto = resto
            mydestination.reviews = reviews
            mydestination.restoDetailViewController = self
            mydestination.coreUser = coreUser
            
        }
        if segue.identifier == "tomapone" {
            let mydestination : MapViewController = segue.destinationViewController as! MapViewController
            mydestination.selectedResto = resto
            
            mydestination.allRestos = restos
            mydestination.screenType = ScreenType.OneResto
                
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
        
        priceLabel.text = textePriceRange(resto.priceRange)
        
        if let myDistance = resto.distance {
            distanceLabel.text = "\(affichageDouble(myDistance)) m"
        }
        if let myAddress = resto.address {
            addressLabel.text = myAddress
        } else {
            addressLabel.text = "Adresse non remplie"
        }
        
        if let myDescription = resto.description {
            descriptionTextView.text = myDescription
        } else {
            descriptionTextView.text = "à remplir"
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        initReview()
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
            if let myDate = reviews[indexPath.row].date {
                cell.dateLabel.text = myDate.absoluteDateToString
            } else {
                cell.dateLabel.text = "pas de date"
            }
            
            cell.rateLabel.text = " \(Int(round(reviews[indexPath.row].rating))) / 20"
            return cell
            
        }
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedRow = indexPath.row
        if selectedRow == reviews.count {
            if let myUser = CoreDataHelper.fetchOneUser() {
                coreUser = myUser
                self.performSegueWithIdentifier("addComment", sender: self)
            } else {
                simpleAlert("Alerte", message: "Vous devez vous connecter !!!!!", controller: self)
            }
            
        }
        //faire quelque chose avec selectedRow
        NSLog("Ligne sélectionnée \(selectedRow)")
        
        
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Avis"
    }
    
    }