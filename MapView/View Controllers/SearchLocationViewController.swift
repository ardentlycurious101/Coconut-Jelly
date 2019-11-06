//
//  SearchLocationViewController.swift
//  MapView
//
//  Created by Elina Lua Ming on 10/26/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

protocol MapViewCenter {
    func getMapViewCenter(_ centerCoordinate: CLLocationCoordinate2D)
}

class SearchLocationViewController: UIViewController {
    
    @IBOutlet weak var MapView: MKMapView!
    var resultSearchController: UISearchController? = nil
    var locationSearchTable: LocationSearchTable? = nil
//    var selectedPin: MKPlacemark? = nil
    var centerDelegate: MapViewCenter!
    
    let regionInMeters: Double = 1000
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        instantiateLocationSearchTable()
        setUpSearchBar()
        connectMapView()
        checkLocationServices()
        setUpMapView()
        locationSearchTable?.handleMapSearchDelegate = self
    }
    
    func connectMapView() {
        locationSearchTable!.MapView = MapView
    }
    
    func instantiateLocationSearchTable() {
        locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as? LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
    }
    
    func setUpSearchBar() {
        // Configure and embed search bar within navigation bar
        let searchBar = resultSearchController!.searchBar
        locationSearchTable?.searchBar = searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search location"
        navigationItem.titleView = resultSearchController?.searchBar
        
        // Configure the UISearchController appearance
        resultSearchController?.hidesNavigationBarDuringPresentation = false
//        resultSearchController?.dimsBackgroundDuringPresentation = true
        resultSearchController?.obscuresBackgroundDuringPresentation = true

        definesPresentationContext = true
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setUpLocationManager()
            checkLocationAuthorization()
        } else {
            print("location services not enabled")
        }
    }
    
    func setUpLocationManager() {
//        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            MapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .denied:
            break
        case .restricted:
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
    
    func setUpMapView() {
        MapView.delegate = self
        mapSetUp(for: initialLocation)
        MapView.addAnnotations(jellyArray)
        MapView.register(JellyView.self,forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }
}

extension SearchLocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: regionInMeters, longitudeDelta: regionInMeters)
        let region = MKCoordinateRegion(center: center, span: span)
        MapView.setRegion(region, animated: true)
    
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension SearchLocationViewController: MKMapViewDelegate {
    
    func mapSetUp(for location: CLLocation) {
        centerMapOnLocation(location: location)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        MapView.setRegion(coordinateRegion, animated: true)
        centerDelegate.getMapViewCenter(MapView.centerCoordinate)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Jelly
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // send center coordinate data to add jelly vc through delegation
        centerDelegate.getMapViewCenter(MapView.centerCoordinate)
    }
}

extension SearchLocationViewController: HandleMapSearch {
    
    func dropPinZoomIn(placemark: MKPlacemark){
        // clear existing pins
        MapView.removeAnnotations(MapView.annotations)

        let region = MKCoordinateRegion(center: placemark.coordinate, latitudinalMeters: regionInMeters/4 , longitudinalMeters: regionInMeters/4)
        MapView.setRegion(region, animated: true)
    }
    
}




