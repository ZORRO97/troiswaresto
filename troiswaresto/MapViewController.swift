//
//  MapViewController.swift
//  troiswaresto
//
//  Created by etudiant-11 on 26/04/2016.
//  Copyright © 2016 francois. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet var mapView : MKMapView!
    @IBOutlet var addressLabel: UILabel?
    @IBOutlet var addRestoButton: UIButton?
    
    var allRestos: [Resto]!
    var selectedResto: Resto?
    var screenType : ScreenType!
    var selectedPosition: CLLocation!
    
    var locationManager =  CLLocationManager()
    let regionRadius: CLLocationDistance = 450
    
    var monPin:Pin!
    
    
    
    
    @IBAction func flecheButtonPressed(){
        self.showUserLocation()
        mapView.setCenterCoordinate(mapView.userLocation.coordinate, animated: true)
    }
    
    @IBAction func addRestoPressed(){
        simpleAlert("nouveau resto", message: "Voulez vous ajouter un nouveau resto ?", controller: self,
                    positiveAction: { ()->() in
                        self.performSegueWithIdentifier("toformnewresto", sender: self)
            }, negativeAction: {})
        
    }
    
    // maj du label indiquant l'adresse choisie en fonction de la position
    func updateAddressLabel() {
        logDebug("update address label")
        let centerCoordinates = mapView.centerCoordinate
        
        let location = CLLocation(latitude: centerCoordinates.latitude, longitude: centerCoordinates.longitude)
        selectedPosition = location
        
        getAdressFromLocation(location) {(address) in
            self.addressLabel?.text = address
        }
    }
    
    // ajouter les pins pour une liste de stations
    func displayPins(restos : [Resto]){
        // mapView.removeAnnotations(mapView.annotations)
        let mapCenterPosition = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        for resto in restos {
            if (mapCenterPosition.distanceFromLocation(resto.position) <= regionRadius * 2) {
                addPin(resto, pinType: .FavoriteResto)
            } else {
                addPin(resto, pinType: .StandardResto)
            }
        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "maptodetail" {
            let mydestination : RestoDetailViewController = segue.destinationViewController as! RestoDetailViewController
            mydestination.resto = selectedResto!
            mydestination.restos = allRestos
        }
        if segue.identifier == "tonewresto" {
            let mydestination : NewRestoViewController = segue.destinationViewController as! NewRestoViewController
            mydestination.restos = allRestos
        }
        if segue.identifier == "toformnewresto" {
            let mydestination : NewRestoViewController = segue.destinationViewController as! NewRestoViewController
            mydestination.address = addressLabel!.text!
            mydestination.position = selectedPosition
            mydestination.screenType = ScreenType.AddResto
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        selectedPosition = CLLocation(latitude: 48.893931, longitude: 2.354374)
        if selectedResto != nil {
            self.centerMapOnLocation(selectedResto!.position)
        } else {
           self.centerMapOnLocation(CLLocation(latitude: 48.893931, longitude: 2.354374))
           // self.centerMapOnLocation(allRestos[0].position)
        }
        self.showUserLocation()
        updateAddressLabel()
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
    
    // MARK: - LocationManager
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // pour supprimer les annotations
        
        displayPins(allRestos)
        updateAddressLabel()
        // print("appel mapview")
    }

    func showUserLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        NSLog("did update location")
        if manager.location != nil {
            locationManager.stopUpdatingLocation()
            
            logDebug("launching request")
            
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: false)
    }
    
    func addPin(myResto : Resto, pinType : PinType) {
        let myPin = Pin(resto : myResto , pinType: pinType)
        mapView.addAnnotation(myPin)
    }
    // MARK: -

}

extension MapViewController : MKMapViewDelegate, CLLocationManagerDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? Pin {
            let identifier = "pin"
            
            var view: MKAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView { // 2
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)//position du popup par rapport à l'image
                
                //pour bien placer le pin
                view.centerOffset = CGPoint(x: 0, y: -25)
                
                view.image = annotation.image
                view.frame.size = CGSize(width: 36, height: 45)

                //
              //  let imageRight = (annotation.pinType == .FavoriteResto) ? "fleche_pleine" : "fleche_creuse"
                let myButton = UIButton(type: .DetailDisclosure)
              //  myButton.frame = CGRect(x: 20, y: 20, width: 20, height: 20)
              //  myButton.setBackgroundImage(UIImage(named: imageRight), forState: .Normal)
                
                if screenType == ScreenType.AllRestos {
                    view.rightCalloutAccessoryView = myButton
                }
                
              //  view.leftCalloutAccessoryView = UIImageView(image: annotation.image)
                
                
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        monPin = view.annotation as! Pin
        
        print("info for ")
        selectedResto = monPin.resto

       self.performSegueWithIdentifier("maptodetail", sender: selectedResto)
        
       // displayPins(allRestos)
    }
}