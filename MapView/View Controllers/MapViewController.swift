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
import Firebase
import GeoFire
import CoreData

class MapViewController: UIViewController {
    
    public var jellies = [Jellies]()
    let persistenceManager = PersistentManager.shared
    var mapHasCenteredOnce = false
    let networkingManager = NetworkingManager.shared
    let notificationCenter = NotificationCenter.default
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    var jellySelected: Jelly? = nil
    
    // MARK:- IBOutlets
    
    @IBOutlet weak var coconutJellyLogo: UIImageView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var MapView: MKMapView!
    @IBAction func refreshButtonTapped(_ sender: Any) {
        refreshJelliesOnMap()
    }
    
    // MARK:- Member Variables
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 250
        
    // MARK:- ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        batchDeleteAllJellies()
        
        checkLocationServices()
        setUpMapView()
        configureUI()
        refreshJelliesOnMap()
        
        // from Networking Manager
        notificationCenter.addObserver(self, selector: #selector(reloadMapWithAnnotations(_:)), name: .newJellyAdded, object: nil)
        
        // from SearchTagsViewController
        notificationCenter.addObserver(self, selector: #selector(reloadMapWithFilteredAnnotations(_:)), name: .filteredJellyAdded, object: nil)
        
        // from SearchTagsViewcontroller
        notificationCenter.addObserver(self, selector: #selector(reloadMapWithAnnotations(_:)), name: .useAllJellies, object: nil)
        
    }
    
    @objc func reloadMapWithAnnotations(_ notification:Notification) {
        // reload with unfiltered array
        removeAnnotations()
        MapView.addAnnotations(MapViewManager.shared.unfilteredJellies)
    }
    
    @objc func reloadMapWithFilteredAnnotations(_ notification:Notification) {
        // reload with filtered array
        removeAnnotations()
        MapView.addAnnotations(MapViewManager.shared.filteredJellies)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    func configureUI() {
        refreshButton.layer.cornerRadius = refreshButton.frame.height/10
        refreshButton.clipsToBounds = true
        
        profileButton.layer.cornerRadius = profileButton.frame.height/10
        profileButton.clipsToBounds = true

        coconutJellyLogo.layer.cornerRadius = coconutJellyLogo.bounds.size.height/10
        coconutJellyLogo.clipsToBounds = true
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    // MARK:- Map Setup
    
    func mapSetUp(for location: CLLocation) {
        centerMapOnLocation(location: location)
        mapHasCenteredOnce = true
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        MapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        if (control == view.rightCalloutAccessoryView) {
            performSegue(withIdentifier: "jelly", sender: self)
        }
        
        if (control == view.detailCalloutAccessoryView) {
            // present view controller with jelly details
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let selectedAnnotation = view.annotation as! Jelly
        jellySelected = Jelly(emoji: selectedAnnotation.emoji, title: selectedAnnotation.title!, tag: selectedAnnotation.tagNames, eventDescription: selectedAnnotation.eventDescription, coordinate: selectedAnnotation.coordinate, startTime: selectedAnnotation.startTime, endTime: selectedAnnotation.endTime, creatorName: selectedAnnotation.creatorName, images: selectedAnnotation.images)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? JellyViewController {
            if segue.identifier == "jelly" {
                controller.inject(jellySelected!)
                slideInTransitioningDelegate.direction = .bottom
                controller.transitioningDelegate = slideInTransitioningDelegate
                controller.modalPresentationStyle = .custom
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let location = userLocation.location {
            if !mapHasCenteredOnce {
                centerMapOnLocation(location: location)
                mapHasCenteredOnce = true
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        refreshJelliesOnMap()
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

// MARK:- Core Data extension

extension MapViewController {
    
    func refreshJelliesOnMap() {
        
        // turn filter off
        notificationCenter.post(name: .turnOffFilter, object: nil)
        
        // batch delete all jellies from core data
//        batchDeleteAllJellies()
        
        // perform networking call:
        //      retrieve jellies within region with Networking Manager
        //      render jellies on mapview with MapViewManager
        networkingManager.getJelliesWithinRegion(within: MapView)
        
    }
    
    func batchDeleteAllJellies() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Jellies")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try persistenceManager.context.execute(batchDeleteRequest)
        } catch {
            fatalError()
        }
        
        MapViewManager.shared.unfilteredJellies = []
        MapViewManager.shared.filteredJellies = []

    }
    
    func removeAnnotations() {
        let annotations = self.MapView.annotations
        self.MapView.removeAnnotations(annotations)
    }
    
}

// MARK:- MapView setup helper functions

extension MapViewController {
    func setUpMapView() {
        guard let userLocation = locationManager.location else { return }

        MapView.delegate = self
        mapSetUp(for: userLocation)
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
            MapView.userTrackingMode = MKUserTrackingMode.follow
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
