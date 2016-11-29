//
//  SelectLocationViewController.swift
//  WhatsTheMove
//
//  Created by Tyler Encke on 11/15/16.
//  Copyright © 2016 WhatsTheMove. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
    func dropPinZoomIn(for placemark: MKPlacemark, of selectedItem: MKMapItem)
}

class SelectLocationViewController: UIViewController {
    
    let WTM = WTMSingleton.instance
    
    let locationManager = CLLocationManager()

    var resultSearchController:UISearchController? = nil
    
    @IBOutlet weak var mapView: MKMapView!
    var selectedLocation: MKMapItem? = nil
    var selectedPin: MKPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Enable location services
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

        // Hide back button
        self.navigationItem.hidesBackButton = true
        
        // Setup locationSearchResultsTable
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTableViewController
        locationSearchTable.mapView = mapView
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        locationSearchTable.handleMapSearchDelegate = self
        
        // This configures the search bar, and embeds it within the navigation bar.
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        
        // Configure the UISearchController appearance
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SelectLocationViewController : CLLocationManagerDelegate {
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

extension SelectLocationViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // Cache the pin
        selectedPin = placemark
        // Clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
    
    func dropPinZoomIn(for placemark: MKPlacemark, of selectedItem: MKMapItem) {
        dropPinZoomIn(placemark: placemark)
        self.selectedLocation = selectedItem
    }
}

extension SelectLocationViewController : MKMapViewDelegate {
    // Map view to add the annotation to the pin
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .contactAdd)
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    // Function to open maps app when clicking map annotation
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // Update newEvent with the location info
        if let selectedLocation = selectedLocation {
            if let location = selectedLocation.placemark.location {
                WTM.newEvent.location.address = parseAddress(for: selectedLocation.placemark)
                WTM.newEvent.location.longitude = location.coordinate.longitude
                WTM.newEvent.location.latitude = location.coordinate.latitude
                if let addressName = selectedLocation.name {
                    WTM.newEvent.location.addressName = addressName
                }
                // Return to new event view
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // Parse address
    private func parseAddress(for selectedItem: MKPlacemark) -> String {
        // Put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // Put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // Put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // Street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // Street name
            selectedItem.thoroughfare ?? "",
            comma,
            // City
            selectedItem.locality ?? "",
            secondSpace,
            // State
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
    
}
