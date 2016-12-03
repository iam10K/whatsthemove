//
//  MapViewController.swift
//  WhatsTheMove
//
//  Created by Tyler Encke on 11/1/16.
//  Copyright © 2016 WhatsTheMove. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    let WTM = WTMSingleton.instance
    
    let locationManager = CLLocationManager()
    
    var events: [Event]?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set events
        events = WTM.events
        
        // Enable location services
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        mapView.removeAnnotations(mapView.annotations)
        populatePins()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    private func populatePins() {
        if let events = events {
            for event in events {
                //print(event.toJSONString())
                // Create a Annotation for each event
                let eventLocation = CLLocationCoordinate2DMake(event.location.latitude, event.location.longitude)
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = eventLocation
                dropPin.title = event.title
                dropPin.subtitle = event.location.address
                mapView.addAnnotation(dropPin)
            }
        }
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
}

extension MapViewController: MKMapViewDelegate {
    // Map view to add the annotation to the pin
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "eventLocation") as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "eventLocation")
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .infoLight)
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    // Function to open maps app when clicking map annotation
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //TODO: Push to event info
    }
    
}
