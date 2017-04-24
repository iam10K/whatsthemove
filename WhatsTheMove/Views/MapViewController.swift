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
    
    var displayedEvents: [Event] = []
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set events
        events = WTM.eventsObservable.observableProperty
        if let events = events {
            displayedEvents = events
        }
        filterEvents()
        
        // Enable location services
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        mapView.removeAnnotations(mapView.annotations)
        populatePins()
        
        if let userLocation = locationManager.location {
            let region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.10, longitudeDelta: 0.10))
            mapView.setRegion(region, animated: false)
        }
    }
    
    func filterEvents() {
        let calender = NSCalendar.autoupdatingCurrent
        let newDate = calender.date(byAdding: .minute, value: -180, to: Date())
        if let newDate = newDate {
            for event in displayedEvents {
                if event.startDate < newDate {
                    if let index = displayedEvents.index(of: event) {
                        displayedEvents.remove(at: index)
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func populatePins() {
        for event in displayedEvents {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "eventTableViewSegue" {
            let vc = segue.destination as! EventTableViewController
            vc.event = sender as? Event
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
        
        for event in displayedEvents {
            if let annotation = view.annotation {
                if let title = annotation.title {
                    if event.title == title {
                        performSegue(withIdentifier: "eventTableViewSegue", sender: event)
                        return
                    }
                }
            }
        }
    }
    
}
