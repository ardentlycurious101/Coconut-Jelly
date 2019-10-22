//
//  AddJelly.swift
//  MapView
//
//  Created by Elina Lua Ming on 10/2/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit
import MapKit

class AddJellyViewController: UIViewController {
        
    @IBOutlet weak var JellyEmoji: UITextField!
    @IBOutlet weak var JellyName: UITextField!
    @IBOutlet weak var JellyDescription: UITextField!
    @IBOutlet weak var JellyTags: UITextField!
    
    @IBOutlet weak var StartTime: UIDatePicker!
    @IBOutlet weak var EndTime: UIDatePicker!
    
    @IBOutlet weak var ImageCollectionView: UICollectionView!
    
    @IBOutlet weak var MapView: MKMapView!
    
    @IBOutlet weak var JellyCreatorDisplayName: UITextField!
    
    @IBAction func CreateJellyTapped(_ sender: Any) {
        
        // create a new Jelly instance with details
        
        // insert new entry in cloud database
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension AddJellyViewController: UITextFieldDelegate {

}
