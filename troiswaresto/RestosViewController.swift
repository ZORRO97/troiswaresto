//
//  RestosViewController.swift
//  troiswaresto
//
//  Created by etudiant-11 on 25/04/2016.
//  Copyright © 2016 francois. All rights reserved.
//

import UIKit
import CoreLocation


class RestosViewController: UIViewController {
    
    @IBOutlet var myTableView:UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    var restos = [Resto]()
    // var myResto: Resto!
    var allRestos = [Resto]() // test 2e tableau
    
    @IBAction func backButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func backToRestos(sender: UIStoryboardSegue){
        logDebug("retour aux restos")
    }
    
    @IBAction func segmentedControlSelected(sender: AnyObject){
        
        switch segmentedControl.selectedSegmentIndex {
        case 0 :
            NSLog("tri distance")
            restos = restos.sort { $0.distance < $1.distance}
        case 1 :
            NSLog("tri note")
            restos = restos.sort { $0.rating > $1.rating }
        case 2 :
            NSLog("tri prix")
            restos = restos.sort { $0.priceRange?.rawValue < $1.priceRange?.rawValue }
            
        default:
            NSLog("autres cas pour \(segmentedControl.selectedSegmentIndex)")
            break
        }
        for resto in self.restos {
            NSLog("rating de \(resto.name) note \(resto.rating) ..")
        }
         myTableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "todetail" {
            let mydestination: RestoDetailViewController = segue.destinationViewController as! RestoDetailViewController
            mydestination.resto = restos[myTableView.indexPathForSelectedRow!.row]
            mydestination.restos = restos
        }
        if segue.identifier == "tomap" ||  segue.identifier == "toaddrestomap"  {
            let myDestination : MapViewController = segue.destinationViewController as! MapViewController
            myDestination.allRestos = restos
            if segue.identifier == "tomap" {
                myDestination.screenType = ScreenType.AllRestos
            } else {
                myDestination.screenType = ScreenType.AddResto
            }
        }
    }
    
    func initResto(){
                
        /*
        restos.append(Resto(restoId: "1", name: "Le Serbe", position: CLLocation(latitude:  48.893741, longitude: 2.350840)))
        restos.append(Resto(restoId: "2", name: "Le Basque", position: CLLocation(latitude: 48.894156, longitude: 2.353471)))
        restos.append(Resto(restoId: "3", name: "Franprix", position: CLLocation(latitude: 48.891420, longitude: 2.351799)))
    */
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getRestosInfoFirebase(myTableView) { (allRestos: [Resto])->() in
            logDebug("fin fonction getRestosInfo")
            self.restos = allRestos
            self.restos = self.restos.sort { $0.priceRange?.rawValue < $1.priceRange?.rawValue }
            self.segmentedControl.selectedSegmentIndex = 2
            self.myTableView.reloadData()
        }
                // initResto()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        myTableView.reloadData()
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

extension RestosViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // A modifier, retourner le nombre de ligne dans la section
        
        return restos.count
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RestoCell", forIndexPath: indexPath) as! RestoCell
        // Ajouter la logique d'affichage du texte dans la cellule de la TableView
        // la variable indexpath.row indique la ligne selectionnée
        // on accède aux IBOutlet de la cellule avec par exemple : cell.name =
        cell.nameLabel.text  = restos[indexPath.row].name
        
        if let myImage = restos[indexPath.row].image {
            cell.cellImageView.image = myImage
        } else {
        cell.cellImageView.image = UIImage(named: "icon120")
        }
                
        if let myDistance = restos[indexPath.row].distance {
        cell.distanceLabel.text = "\(affichageDouble(myDistance))"
        }
        if let myPriceRange = restos[indexPath.row].priceRange {
            switch myPriceRange {
            case .Cheap : cell.priceRangeLabel.text = "€"
            case .Normal : cell.priceRangeLabel.text = "€€"
            case .Expensive : cell.priceRangeLabel.text = "€€€"
                
            }
        } else {
            
        
         cell.priceRangeLabel.text = "Inconnu"
        }
        cell.priceRangeLabel.text = textePriceRange(restos[indexPath.row].priceRange)
        // gérer l'affichage des étoiles
        if let myRating = self.restos[indexPath.row].rating {
            let nbStars = Int(round(myRating / 4))
            if nbStars == 5 {
                cell.star5ImageView.image = UIImage(named: "fleche_pleine")
            } else {
                cell.star5ImageView.image = UIImage(named: "fleche_creuse")
            }
            if nbStars >= 4 {
                cell.star4ImageView.image = UIImage(named: "fleche_pleine")
            } else {
                cell.star4ImageView.image = UIImage(named: "fleche_creuse")
            }
            if nbStars >= 3 {
                cell.star3ImageView.image = UIImage(named: "fleche_pleine")
            } else {
                cell.star3ImageView.image = UIImage(named: "fleche_creuse")
            }
            if nbStars >= 2 {
                cell.star2ImageView.image = UIImage(named: "fleche_pleine")
            } else {
                cell.star2ImageView.image = UIImage(named: "fleche_creuse")
            }
            if nbStars >= 1 {
                cell.star1ImageView.image = UIImage(named: "fleche_pleine")
            } else {
                cell.star1ImageView.image = UIImage(named: "fleche_creuse")
            }
        } else {
            cell.star1ImageView.image = UIImage(named: "fleche_creuse")
            cell.star2ImageView.image = UIImage(named: "fleche_creuse")
            cell.star3ImageView.image = UIImage(named: "fleche_creuse")
            cell.star4ImageView.image = UIImage(named: "fleche_creuse")
            cell.star5ImageView.image = UIImage(named: "fleche_creuse")
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedRow = indexPath.row
        //faire quelque chose avec selectedRow
        NSLog("Ligne sélectionnée \(selectedRow)")
        // myResto = restos[indexPath.row]
        self.performSegueWithIdentifier("todetail", sender: self)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    // personnalisation du slide to left
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete") { action, index in
            print("Delete button tapped")
            // self.velibStations.removeAtIndex(indexPath.row)
            simpleAlert("Suppression", message: "voulez vous supprimer ce resto ?", controller: self, positiveAction:
                {_ in
                    NSLog("lancement de la suppression du resto")
                    delRestoInCloud(self.restos[indexPath.row].restoId, completionHandler: { success in
                        if success {
                            self.restos.removeAtIndex(indexPath.row)
                            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                            
                        }
                        simpleAlert("résultat suppression", message: success ? "Réussi" : "Echec" , controller: self)
                    })
                    
            })
            
            
        }
        return [delete]
    }
}