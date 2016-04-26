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
        /*restos.append(Resto(restoId: 1, name: "Le serbe", position: CLLocation(latitude: 48.953, longitude: 2.30)))
        
        
        restos.append(Resto(restoId: 2, name: "le basque", position: CLLocation(latitude: 48.653, longitude: 2.37)))
        
        restos.append(Resto(restoId: 2, name: "le landais", position: CLLocation(latitude: 48.843, longitude: 2.38)))
         */
        
        restos.append(Resto(restoId: "1", name: "Le Serbe", position: CLLocation(latitude:  48.893741, longitude: 2.350840)))
        restos.append(Resto(restoId: "2", name: "Le Basque", position: CLLocation(latitude: 48.894156, longitude: 2.353471)))
        restos.append(Resto(restoId: "3", name: "Franprix", position: CLLocation(latitude: 48.891420, longitude: 2.351799)))
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initResto()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
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
        cell.cellImageView.image = UIImage(named: "icon120")
        cell.distanceLabel.text = "\(restos[indexPath.row].distance)"
        cell.priceRangeLabel.text = "Pourri"
        cell.rateLabel.text = "4 étoiles"
        
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