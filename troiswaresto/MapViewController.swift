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
    
    var allRestos: [Resto]!
    var selectedResto: Resto?
    
    var locationManager =  CLLocationManager()
    let regionRadius: CLLocationDistance = 450
    
    var monPin:Pin!
    
    // Action pour le bouton retour
    @IBAction func backButtonPressed(){
        print("Button back pressed")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func flecheButtonPressed(){
        self.showUserLocation()
        mapView.setCenterCoordinate(mapView.userLocation.coordinate, animated: true)
    }
    
    // ajouter les pins pour une liste de stations
    func displayPins(restos : [Resto]){
        // mapView.removeAnnotations(mapView.annotations)
        let mapCenterPosition = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        print(" les restos")
        for resto in restos {
            if (mapCenterPosition.distanceFromLocation(resto.position) <= regionRadius * 2) {
               /* if (stationsIds.indexOf(station.numberStation) != nil) {
                    addPin(resto, pinType: .FavoriteResto)
                } else {
                    addPin(resto,pinType: .StandardResto)
                }
                 */
                print("resto à afficher \(resto.name)")
                addPin(resto, pinType: .FavoriteResto)
            } else {
                addPin(resto, pinType: .StandardResto)
            }
        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "rewind" {
            let mydestination : RestoDetailViewController = segue.destinationViewController as! RestoDetailViewController
            mydestination.resto = selectedResto!
            mydestination.restos = allRestos
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if selectedResto != nil {
            self.centerMapOnLocation(selectedResto!.position)
        } else {
           // self.centerMapOnLocation(CLLocation(latitude: 48.853, longitude: 2.35))
            self.centerMapOnLocation(allRestos[0].position)
        }
        self.showUserLocation()
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
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // pour supprimer les annotations
        
        displayPins(allRestos)
        print("appel mapview")
    }
    
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
                view.rightCalloutAccessoryView = myButton
                
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

       self.performSegueWithIdentifier("rewind", sender: selectedResto)
        
       // displayPins(allRestos)
    }
}