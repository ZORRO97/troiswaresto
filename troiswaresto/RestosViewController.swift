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
    
    var restos = [Resto]()
    // var myResto: Resto!
    
    @IBAction func backButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "todetail" {
            let mydestination: RestoDetailViewController = segue.destinationViewController as! RestoDetailViewController
            mydestination.resto = restos[myTableView.indexPathForSelectedRow!.row]
            mydestination.restos = restos
        }
        if segue.identifier == "tomap" {
            let myDestination : MapViewController = segue.destinationViewController as! MapViewController
            myDestination.allRestos = restos
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
        cell.distanceLabel.text = "\(restos[indexPath.row].distance)"
        if let myPriceRange = restos[indexPath.row].priceRange {
            switch myPriceRange {
            case .Cheap : cell.priceRangeLabel.text = "Bon Marché"
            case .Normal : cell.priceRangeLabel.text = "Normal"
            case .Expensive : cell.priceRangeLabel.text = "très cher"
                
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
        }
        if nbStars >= 4 {
            cell.star4ImageView.image = UIImage(named: "fleche_pleine")
        }
        if nbStars >= 3 {
            cell.star3ImageView.image = UIImage(named: "fleche_pleine")
        }
        if nbStars >= 2 {
            cell.star2ImageView.image = UIImage(named: "fleche_pleine")
        }
        if nbStars >= 1 {
            cell.star1ImageView.image = UIImage(named: "fleche_pleine")
        }
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
}