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
    
    @IBOutlet var nameTitleLabel: UILabel!
    @IBOutlet var ratingTitleLabel : UILabel!
    @IBOutlet var priceTitleLabel : UILabel!
    @IBOutlet var distanceTitleLabel : UILabel!
    @IBOutlet var addressTitleLabel : UILabel!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ratingLabel : UILabel!
    @IBOutlet var priceLabel : UILabel!
    @IBOutlet var distanceLabel : UILabel!
    @IBOutlet var addressLabel : UILabel!
    
    @IBOutlet var descriptionTextView : UITextView!
    
    @IBOutlet var mapBarButtonItem : UIBarButtonItem!
    
    @IBOutlet var reviewTableView: UITableView!
    
    
    var resto : Resto!
    var restos = [Resto]()
    var reviews = [Review]()
    var coreUser : CoreDataUser!
    
   
    
    func initReview(){
        reviews = self.resto.reviews
        /* tri de dates
        //Pour comparer des dates
        $0.date!.timeIntervalSinceDate($1.date!) > 0
        //ou bien
        $0.date!.compare($1.date!) == NSComparisonResult.OrderedDescending
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
        
        // en fonction de la valeur du rating afficher plus ou moins d'étoiles
        if let myRating = self.resto.rating {
            ratingLabel.text = "\(Int(myRating)) / 20"
        } else {
            ratingLabel.text = "pas d'avis"
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
                cell.dateLabel.text = myDate.reductDateToString
            } else {
                cell.dateLabel.text = ""
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
                simpleAlert("Vous n'êtes pas connecté !", message: "se connecter ?", controller: self, positiveAction: {
                    _ in
                    self.performSegueWithIdentifier("detailtologin", sender: self)
                    }, negativeAction: {})
                
            }
            
        }
        // faire quelque chose avec selectedRow
        // NSLog("Ligne sélectionnée \(selectedRow)")
        
        
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Avis"
    }
    
    }