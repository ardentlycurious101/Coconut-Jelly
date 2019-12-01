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
    public var filteredJellies = [Jellies]()
    let persistenceManager = PersistentManager.shared
    var mapHasCenteredOnce = false
    let networkingManager = NetworkingManager.shared
    let notificationCenter = NotificationCenter.default
    
    // MARK:- IBOutlets
    @IBOutlet weak var MapView: MKMapView!
    
    // MARK:- Member Variables
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
        
    // MARK:- ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationServices()
        setUpMapView()
        refreshJelliesOnMap()
        
        // from Networking Manager
        notificationCenter.addObserver(self, selector: #selector(reloadMapWithAnnotations(_:)), name: .newJellyAdded, object: nil)
        
        // from SearchTagsViewController
        notificationCenter.addObserver(self, selector: #selector(reloadMapWithFilteredAnnotations(_:)), name: .filteredJellyAdded, object: nil)
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
        return .lightContent
    }
    
    func getMapViewEdgeCoordinates() -> [CLLocationCoordinate2D] {
        var points: [CLLocationCoordinate2D] = []
        
        // get CGPoints of MapView's four corners.
        let topLeftPoint = CGPoint(x: self.MapView.bounds.origin.x, y: self.MapView.bounds.origin.y)
        let topRightPoint = CGPoint(x: self.MapView.bounds.origin.x + self.MapView.bounds.size.width, y: self.MapView.bounds.origin.y)
        let bottomLeftPoint = CGPoint(x: self.MapView.bounds.origin.x, y: self.MapView.bounds.origin.y + self.MapView.bounds.size.height)
        let bottomRightPoint = CGPoint(x: self.MapView.bounds.origin.x + self.MapView.bounds.size.width, y: self.MapView.bounds.origin.y + self.MapView.bounds.size.height)
        
        // convert the points into coordinates
        let topLeft = MapView.convert(topLeftPoint, toCoordinateFrom: MapView)
        let topRight = MapView.convert(topRightPoint, toCoordinateFrom: MapView)
        let bottomLeft = MapView.convert(bottomLeftPoint, toCoordinateFrom: MapView)
        let bottomRight = MapView.convert(bottomRightPoint, toCoordinateFrom: MapView)
        
        points.append(topLeft)
        points.append(topRight)
        points.append(bottomLeft)
        points.append(bottomRight)
        
        return points
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
        
        if (control == view.detailCalloutAccessoryView) {
            // present view controller with jelly details
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
    
    func createJelly() {
        let jelly = Jellies(context: persistenceManager.context)
        jelly.title = "testing 3"
        persistenceManager.save()
    }
    
    func refreshJelliesOnMap() {
        
        // batch delete all jellies from core data
        batchDeleteAllJellies()
        
        // perform networking call:
        //      retrieve jellies within region with Networking Manager
        //      render jellies on mapview with MapViewManager

        networkingManager.getJelliesWithinRegion(within: MapView)
        
//        // from Networking Manager
//        notificationCenter.addObserver(self, selector: #selector(reloadMapWithAnnotations(_:)), name: .newJellyAdded, object: nil)
        
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
        MapViewManager.shared.unfilteredJellies = []

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
