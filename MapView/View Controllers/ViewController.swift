//
//  ViewController.swift
//  MapView
//
//  Created by Elina Lua Ming on 10/2/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    // MARK:- IBOutlets
    @IBOutlet weak var MapView: MKMapView!
    
    // MARK:- Member Variables
    let locationManager = CLLocationManager()
    
    // MARK:- ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        MapView.delegate = self
        checkLocationServices()
        mapSetUp(for: initialLocation)
    }
}


