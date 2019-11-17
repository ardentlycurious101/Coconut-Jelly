//
//  ViewController.swift
//  MapView
//
//  Created by Elina Lua Ming on 10/2/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    // MARK:- IBOutlets
    @IBOutlet weak var MapView: MKMapView!
    
    // MARK:- Member Variables
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
//    let userLocation: CLLocationCoordinate2D?
        
    // MARK:- ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        setUpMapView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setUpMapView() {
        guard let userLocation = locationManager.location else { return }

        MapView.delegate = self
        mapSetUp(for: userLocation)
        MapView.addAnnotations(jellyArray)
        MapView.register(JellyView.self,forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)        
    }
    
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setUpLocationManager()
            checkLocationAuthorization()
        } else {
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in
                // Redirect to Settings app
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
            let alert = UIAlertController(title: "Location Service Disabled", message: "Please enable location services to allow Coconut Jelly to use your location.", preferredStyle: .alert)
            alert.addAction(settingsAction)
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            // do map stuff
            MapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
        // show alert, instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            // show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        default:
            break
        }
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            MapView.setRegion(region, animated: true)
        }
    }

}

extension MapViewController: MKMapViewDelegate {
    
    // MARK:- Map Setup
    
    func mapSetUp(for location: CLLocation) {
        centerMapOnLocation(location: location)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        MapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        if (control == view.rightCalloutAccessoryView) {
            let location = view.annotation as! Jelly
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
            location.mapItem().openInMaps(launchOptions: launchOptions)
        }
        
        if (control == view.leftCalloutAccessoryView) {
            print("left callout accessory clicked")
        }
    }
    
    // TODO: CUSTOMIZE ANNOTATION CALL OUT VIEW
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // presentation controller animated with details of annotation

        
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    
     // MARK:- Location Manager
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        MapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("this is error: \(error.localizedDescription)")
    }
    
}
